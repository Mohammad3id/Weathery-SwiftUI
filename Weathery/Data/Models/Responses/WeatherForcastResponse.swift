//
//  WeatherForecast.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//
import Foundation

struct WeatherForecastResponse: Decodable {
    let list: [DayWeatherInfo]
    struct DayWeatherInfo: Decodable {
        let dt: Date
        let weather: [WeatherResponseStructs.WeatherCondition]
        let main: WeatherResponseStructs.WeatherMain
        let wind: WeatherResponseStructs.WeatherWind
        let clouds: WeatherResponseStructs.WeatherClouds
        let visibility: Int
        let pop: Double
    }
    
    let city: WeatherCity
    struct WeatherCity: Decodable {
        let id: Int
        let name: String
        let country: String
        let timezone: Int
        let coord: WeatherResponseStructs.WeatherCoordinates
    }
}



