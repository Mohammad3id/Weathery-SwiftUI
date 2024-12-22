//
//  WeatherReport.swift
//  Weathery
//
//  Created by Mohammad Eid on 20/12/2024.
//

struct WeatherReport {
    let current: WeatherSnapshot
    
    let nextHours: [WeatherSnapshot]
    
    let nextDays: [WeatherSnapshot]
}
