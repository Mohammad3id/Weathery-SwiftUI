//
//  WeatherInfo.swift
//  Weathery
//
//  Created by Mohammad Eid on 16/12/2024.
//
import Foundation

struct WeatherCoordinates: Decodable {
    let lon: Double
    let lat: Double
}

struct WeatherCondition: Decodable {
    let id: Int
    let main: String
    let description: String
}

struct WeatherWind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct WeatherClouds: Decodable {
    let all: Int
}

struct WeatherMain: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}
