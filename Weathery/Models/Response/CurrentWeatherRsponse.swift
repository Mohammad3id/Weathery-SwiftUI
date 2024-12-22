//
//  WeatherDataRsponse.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//
import Foundation

struct WeatherRsponse: Decodable {
    let coord: WeatherCoordinates
    struct WeatherCoordinates: Decodable {
        let lon: Double
        let lat: Double
    }
    
    let weather: WeatherCondition
    struct WeatherCondition: Decodable {
        let id: Int
        let main: String
        let description: String
    }
    
    let main: WeatherMain
    struct WeatherMain: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
    }
    
    let visibility: Int
    
    let wind: WeatherWind
    struct WeatherWind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
    
    let clouds: WeatherClouds
    struct WeatherClouds: Decodable {
        let all: Int
    }
    
    let timezone: Int
}

//protocol WeatherData: Decodable {
//    var dt: Date { get }
//    
//    var pressure: Int { get }
//    var humidity: Int { get }
//    var dewPoint: Double { get }
//    var windSpeed: Double { get }
//    var windGust: Double? { get }
//    var windDeg: Int { get }
//    var clouds: Int { get }
//    var uvi: Int { get }
//    
//    var weather: [WeatherCondition] { get }
//}
