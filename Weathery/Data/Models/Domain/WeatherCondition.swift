//
//  WeatherCondition.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

enum WeatherCondition: String {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case clear
    case mist
    case cloudy
    case unknown
}

extension WeatherCondition {
    /// Based on weather condition codes listed [here](https://openweathermap.org/weather-conditions)
    static func from(code: Int) -> WeatherCondition {
        return switch (code) {
        case 200...299: .thunderstorm
        case 300...399: .drizzle
        case 500...599: .rain
        case 600...699: .snow
        case 701: .mist
        case 800: .clear
        case 801...809: .cloudy
        default: .unknown
        }
    }
}

extension WeatherCondition {
    var image: String {
        switch self {
        case .clear:
            "sun.max.fill"
        case .thunderstorm:
            "cloud.bolt.rain.fill"
        case .drizzle:
            "cloud.sun.rain.fill"
        case .rain:
            "cloud.heavyrain.fill"
        case .snow:
            "cloud.snow.fill"
        case .mist:
            "cloud.fog.fill"
        case .cloudy:
            "cloud.fill"
        case .unknown:
            "questionmark.circle.fill"
        }
    }
}
