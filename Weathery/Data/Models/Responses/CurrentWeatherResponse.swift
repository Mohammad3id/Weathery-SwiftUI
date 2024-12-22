//
//  WeatherDataRsponse.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//
import Foundation

struct CurrentWeatherResponse: Decodable {
    let dt: Date
    let coord: WeatherCoordinates
    let weather: [WeatherCondition]
    let main: WeatherMain
    let wind: WeatherWind
    let clouds: WeatherClouds
    let visibility: Int
    let timezone: Int
}
