//
//  WeatherDataRsponse.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//
import Foundation

struct CurrentWeatherResponse: Decodable {
    let dt: Date
    let coord: WeatherResponseStructs.WeatherCoordinates
    let weather: [WeatherResponseStructs.WeatherCondition]
    let main: WeatherResponseStructs.WeatherMain
    let wind: WeatherResponseStructs.WeatherWind
    let clouds: WeatherResponseStructs.WeatherClouds
    let visibility: Int
    let timezone: Int
    let id: Int // City id
    let name: String // City name
    let sys: Sys
    struct Sys: Decodable {
        let country: String
    }
}


