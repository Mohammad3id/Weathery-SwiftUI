//
//  WeatherForcast.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//
import Foundation

struct WeatherForcastResponse: Decodable {
    let list: [DayWeatherInfo]
    struct DayWeatherInfo: Decodable {
        let dt: Date
        let weather: [WeatherCondition]
        let main: WeatherMain
        let wind: WeatherWind
        let clouds: WeatherClouds
        let visibility: Int
        let pop: Double
    }
    
    let city: WeatherCity
    struct WeatherCity: Decodable {
        let id: Int
        let timezone: Int
        let coord: WeatherCoordinates
    }
}



