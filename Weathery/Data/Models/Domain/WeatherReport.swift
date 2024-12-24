//
//  WeatherReport.swift
//  Weathery
//
//  Created by Mohammad Eid on 20/12/2024.
//

struct WeatherReport {
    let location: Location
    struct Location {
        let city: String?
        let country: String?
        let latitude: Double
        let longitude: Double
    }
    
    let info: Info
    struct Info {
        let current: WeatherSnapshot
        let nextHours: [WeatherSnapshot]
        let nextDays: [WeatherSnapshot]
    }
}


extension WeatherReport.Location: Mockable {
    static var mock: WeatherReport.Location {
        WeatherReport.Location(
            city: "Liverpool",
            country: "UK",
            latitude: 20,
            longitude: 20
        )
    }
}
