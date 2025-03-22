//
//  WeatherController.swift
//  Weathery
//
//  Created by Mohammad Eid on 16/12/2024.
//

import SwiftUI
import CoreLocation

@Observable @MainActor
class WeatherController {
    private let weatherService = WeatherService()
    
    var state: WeatherScreenState = .loading
    
    func loadWeatherForCurrentLocation() async {
        let location: CLLocation
        
        do {
            location = try await LocationManager().requestLocation()
        } catch {
            state = .failure(message: error.localizedDescription)
            return
        }
        
        await self.loadWeatherForLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    func loadWeatherForLocation(latitude: Double, longitude: Double) async {
        do {
            async let weatherReport = weatherService.getWeatherReport(latitude: latitude, longitude: longitude)
            state = .success(weatherReport: try await weatherReport)
        } catch {
            state = .failure(message: error.localizedDescription)
        }
        
    }
}


enum WeatherScreenState {
    case loading
    case failure(message: String)
    case success(weatherReport: WeatherReport)
}
