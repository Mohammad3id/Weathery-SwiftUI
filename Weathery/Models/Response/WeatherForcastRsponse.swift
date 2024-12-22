//
//  WeatherDataRsponse.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//
import Foundation

struct WeatherForcastRsponse: Decodable {
    let list: [WeatherForcastRsponseDay]
    struct WeatherForcastRsponseDay: Decodable {
        let dt: Date
        let weather: WeatherCondition
        let main: WeatherMain
        let wind: WeatherWind
        let clouds: WeatherClouds
        let visibility: Int
        let pop: Double
        let timezone: Int
    }
    let coord: WeatherCoordinates
}



