//
//  WeatherSnapshot.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

import Foundation

struct WeatherSnapshot {
    let date: Date
    
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

    static func from(response: WeatherForecastResponse) -> [WeatherSnapshot] {
        response.list.map { day in
            WeatherSnapshot(
                date: day.dt,
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
    static private func buildWeatherSnapshot(date: Date) -> WeatherSnapshot {
        WeatherSnapshot(
            date: date,
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
    
    static var mock: WeatherSnapshot {
        buildWeatherSnapshot(date: Date.now)
    }
    
    static var mockList: [WeatherSnapshot] {
        let dates = (1...5).map(
            {
                Calendar.current.date(
                    byAdding: .hour,
                    value: $0,
                    to: Date.now
                )!
            })
        return dates.map({buildWeatherSnapshot(date: $0)})
    }
}
