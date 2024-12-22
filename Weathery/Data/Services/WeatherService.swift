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
    private let weatherForcastBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    private func buildUrl(with url: String, lat: Double, lon: Double) -> URL {
        URL(string: url)!.appending(
            queryItems: [
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
            ]
        )
    }
    
    func getCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherRsponse {
        let (data, _) = try await URLSession.shared.data(
            from: buildUrl(with: currentWeatherBaseUrl, lat: lat, lon: lon)
        )
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(CurrentWeatherRsponse.self, from: data)
    }
    
    func getWeatherForcast(lat: Double, lon: Double) async throws -> WeatherForcastRsponse {
        let (data, _) = try await URLSession.shared.data(
            from: buildUrl(with: weatherForcastBaseUrl, lat: lat, lon: lon)
        )
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(WeatherForcastRsponse.self, from: data)
    }
}
