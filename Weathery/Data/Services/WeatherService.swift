//
//  WeatherRepo.swift
//  Weathery
//
//  Created by Mohammad Eid on 16/12/2024.
//

import Foundation

class WeatherService {
    private let apiKey = "631edbdba3a5e9051d3f382091446123"
    private let currentWeatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let weatherForecastBaseUrl = "https://api.openweathermap.org/data/2.5/forecast"
    
    func getWeatherReport(lat: Double, lon: Double) async throws -> WeatherReport {
        async let currentTask = getCurrentWeather(lat: lat, lon: lon)
        async let forecastTask = getWeatherForecast(lat: lat, lon: lon)
        
        let current = try await currentTask
        let forecast = try await forecastTask
        
        return WeatherReport(
            current: current,
            nextHours: computeNextHoursForecast(from: forecast),
            nextDays: computeNextDaysForecast(from: forecast)
        )
    }
}

// API request logic
extension WeatherService {
    private func buildUrl(with baseUrl: String, lat: Double, lon: Double) -> URL {
        URL(string: baseUrl)!.appending(
            queryItems: [
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
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
    
    private func getCurrentWeather(lat: Double, lon: Double) async throws -> WeatherSnapshot {
        let (data, _) = try await URLSession.shared.data(
            from: buildUrl(with: currentWeatherBaseUrl, lat: lat, lon: lon)
        )
        
        let currentWeatherResponse = try buildDecoder().decode(CurrentWeatherResponse.self, from: data)
        return .from(response: currentWeatherResponse)
    }
    
    private func getWeatherForecast(lat: Double, lon: Double) async throws -> [WeatherSnapshot] {
        let (data, _) = try await URLSession.shared.data(
            from: buildUrl(with: weatherForecastBaseUrl, lat: lat, lon: lon)
        )

        let weatherForecastResponse = try buildDecoder().decode(WeatherForecastResponse.self, from: data)
        return WeatherSnapshot.from(response: weatherForecastResponse)
    }
}

// Forecast computations
extension WeatherService {
    private func computeNextHoursForecast(from weatherSnapshots: [WeatherSnapshot]) -> [WeatherSnapshot] {
        return Array(weatherSnapshots.prefix(5))
    }
    
    private func computeNextDaysForecast(from snapshots: [WeatherSnapshot]) -> [WeatherSnapshot] {
        let today = Calendar.current.startOfDay(for: snapshots.first!.date)
        let nextDays = Calendar.current.dates(byAdding: .day, startingAt: today).dropFirst().prefix(4)
        
        var nextDaysForecast = [WeatherSnapshot]()
        
        for day in nextDays {
            let daySnapshots = snapshots.filter({Calendar.current.isDate($0.date, inSameDayAs: day)})
            let averageSnapshot = computeAverageWeather(of: daySnapshots)
            nextDaysForecast.append(averageSnapshot)
        }
        
        return nextDaysForecast
    }
    
    private func computeAverageWeather(of snapshots: [WeatherSnapshot]) -> WeatherSnapshot {
        assert(!snapshots.isEmpty)
        assert(snapshots.allSatisfy({$0.location.id == snapshots.first!.location.id}))
        
        return WeatherSnapshot(
            date: Date(timeIntervalSince1970: snapshots.map({$0.date.timeIntervalSince1970}).average),
            location: snapshots.first!.location,
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
