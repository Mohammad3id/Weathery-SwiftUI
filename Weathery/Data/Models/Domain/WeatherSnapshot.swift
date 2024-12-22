//
//  WeatherInfo.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

import Foundation

struct WeatherSnapshot {
    let date: Date
    
    let location: Location
    struct Location {
        let id: Int
        let name: String
        let country: String
        let timezone: Int
        let latitude: Double
        let longitude: Double
    }
    
    let condition: WeatherCondition
    
    let temperature: Temperature
    struct Temperature {
        let actual: Double
        let feelsLike: Double
        let min: Double
        let max: Double
    }
    
    let wind: Wind
    struct Wind {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    let humidity: Int
    let pressure: Int
    let visibility: Int
}


extension WeatherSnapshot {
    static func from(response: CurrentWeatherResponse) -> WeatherSnapshot {
        WeatherSnapshot(
            date: response.dt,
            location: Location(
                id: response.id,
                name: response.name,
                country: response.sys.country,
                timezone: response.timezone,
                latitude: response.coord.lat,
                longitude: response.coord.lon
            ),
            condition: .from(code: response.weather.first?.id ?? 0),
            temperature: Temperature(
                actual: response.main.temp,
                feelsLike: response.main.feelsLike,
                min: response.main.tempMin,
                max: response.main.tempMax
            ),
            wind: Wind(
                speed: response.wind.speed,
                deg: response.wind.deg,
                gust: response.wind.gust
            ),
            humidity: response.main.humidity,
            pressure: response.main.pressure,
            visibility: response.visibility
        )
    }

    static func from(response: WeatherForcastResponse) -> [WeatherSnapshot] {
        response.list.map { day in
            WeatherSnapshot(
                date: day.dt,
                location: Location(
                    id: response.city.id,
                    name: response.city.name,
                    country: response.city.country,
                    timezone: response.city.timezone,
                    latitude: response.city.coord.lat,
                    longitude: response.city.coord.lon
                ),
                condition: .from(code: day.weather.first?.id ?? 0),
                temperature: Temperature(
                    actual: day.main.temp,
                    feelsLike: day.main.feelsLike,
                    min: day.main.tempMin,
                    max: day.main.tempMax
                ),
                wind: Wind(
                    speed: day.wind.speed,
                    deg: day.wind.deg,
                    gust: day.wind.gust
                ),
                humidity: day.main.humidity,
                pressure: day.main.pressure,
                visibility: day.visibility
            )
        }
    }
}

extension WeatherSnapshot: Mockable {
    static var mock: WeatherSnapshot {
        WeatherSnapshot(
            date: Date.now,
            location: Location(
                id: 0,
                name: "Liverpool",
                country: "GB",
                timezone: 0,
                latitude: 0,
                longitude: 0
            ),
            condition: .thunderstorm,
            temperature: Temperature(
                actual: 20,
                feelsLike: 21,
                min: 19,
                max: 22
            ),
            wind: Wind(
                speed: 20,
                deg: 20,
                gust: 0.1
            ),
            humidity: 20,
            pressure: 20,
            visibility: 1000
        )
    }
}
