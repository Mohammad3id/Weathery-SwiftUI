//
//  WeatherRepo.swift
//  Weathery
//
//  Created by Mohammad Eid on 16/12/2024.
//

import Foundation
import CoreLocation

class WeatherService {
    private let apiKey = "631edbdba3a5e9051d3f382091446123"
    private let currentWeatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let weatherForecastBaseUrl = "https://api.openweathermap.org/data/2.5/forecast"
    
    func getWeatherReport(latitude: Double, longitude: Double) async throws -> WeatherReport {
        async let currentTask = getCurrentWeather(latitude: latitude, longitude: longitude)
        async let forecastTask = getWeatherForecast(latitude: latitude, longitude: longitude)
        async let placemarkTask = LocationManager().getPlacemark(latitude: latitude, longitude: longitude)
        
        let current = try await currentTask
        let forecast = try await forecastTask
        let placemark = try await placemarkTask
        
        return WeatherReport(
            location: WeatherReport.Location(
                city: placemark.locality,
                country: placemark.country,
                latitude: latitude,
                longitude: longitude
            ),
            info: WeatherReport.Info(
                current: current,
                nextHours: computeNextHoursForecast(from: forecast),
                nextDays: computeNextDaysForecast(from: forecast)
            )
        )
    }
}

// API request logic
extension WeatherService {
    private func buildUrl(with baseUrl: String, latitude: Double, longitude: Double) -> URL {
        URL(string: baseUrl)!.appending(
            queryItems: [
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lat", value: "\(latitude)"),
                URLQueryItem(name: "lon", value: "\(longitude)"),
//                URLQueryItem(name: "lang", value: "ar"),
            ]
        )
    }
    
    private func buildDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    private func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherSnapshot {
        let (data, _) = try await URLSession.shared.data(
            from: buildUrl(with: currentWeatherBaseUrl, latitude: latitude, longitude: longitude)
        )
        
        let currentWeatherResponse = try buildDecoder().decode(CurrentWeatherResponse.self, from: data)
        return .from(response: currentWeatherResponse)
    }
    
    private func getWeatherForecast(latitude: Double, longitude: Double) async throws -> [WeatherSnapshot] {
        let (data, _) = try await URLSession.shared.data(
            from: buildUrl(with: weatherForecastBaseUrl, latitude: latitude, longitude: longitude)
        )

        let weatherForecastResponse = try buildDecoder().decode(WeatherForecastResponse.self, from: data)
        return WeatherSnapshot.from(response: weatherForecastResponse)
    }
}

// Forecast computations
extension WeatherService {
    private func computeNextHoursForecast(from snapshots: [WeatherSnapshot]) -> [WeatherSnapshot] {
        return Array(snapshots.prefix(5))
    }
    
    private func computeNextDaysForecast(from snapshots: [WeatherSnapshot]) -> [WeatherSnapshot] {
        let today = Calendar.current.startOfDay(for: snapshots.first!.date)
        let nextDays = Calendar.current.dates(byAdding: .day, startingAt: today).prefix(4)
        
        var nextDaysForecast = [WeatherSnapshot]()
        
        for day in nextDays {
            let daySnapshots = snapshots.filter({Calendar.current.isDate($0.date, inSameDayAs: day)})
            if daySnapshots.isEmpty { continue }
            let averageSnapshot = computeAverageWeather(of: daySnapshots)
            nextDaysForecast.append(averageSnapshot)
        }
        
        return nextDaysForecast
    }
    
    private func computeAverageWeather(of snapshots: [WeatherSnapshot]) -> WeatherSnapshot {
        assert(!snapshots.isEmpty)
        
        return WeatherSnapshot(
            date: Date(timeIntervalSince1970: snapshots.map({$0.date.timeIntervalSince1970}).average),
            condition: snapshots.map({$0.condition}).mostFrequent()!,
            temperature: WeatherSnapshot.Temperature(
                actual: snapshots.map({$0.temperature.actual}).average,
                feelsLike: snapshots.map({$0.temperature.feelsLike}).average,
                min: snapshots.map({$0.temperature.min}).average,
                max: snapshots.map({$0.temperature.max}).average
            ),
            wind: WeatherSnapshot.Wind(
                speed: snapshots.map({$0.wind.speed}).average,
                deg: Int(snapshots.map({$0.wind.deg}).average.rounded()),
                gust: snapshots.contains(where: {$0.wind.gust != nil}) ? snapshots.compactMap({$0.wind.gust}).average : nil
            ),
            humidity: Int(snapshots.map({$0.humidity}).average.rounded()),
            pressure: Int(snapshots.map({$0.pressure}).average.rounded()),
            visibility: Int(snapshots.map({$0.visibility}).average.rounded())
        )
    }
}
