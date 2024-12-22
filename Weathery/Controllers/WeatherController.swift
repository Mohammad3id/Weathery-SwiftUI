//
//  WeatherController.swift
//  Weathery
//
//  Created by Mohammad Eid on 16/12/2024.
//

import SwiftUI
import CoreLocation

@Observable
class WeatherController {
    private let weatherService: WeatherService
    private let locationManager: LocationManager
    
    var state: WeatherScreenState = .loading
    
    init(weatherService: WeatherService, locationManager: LocationManager) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
    
    @MainActor
    func loadWeatherForCurrentLocation() async {
        let location: CLLocationCoordinate2D
        
        do {
            location = try await locationManager.requestLocation()
        } catch {
            state = .failure(message: error.localizedDescription)
            return
        }
        
        await self.loadWeatherForLocation(
            lat: location.latitude,
            lon: location.longitude
        )
    }
    
    @MainActor
    func loadWeatherForLocation(lat: Double, lon: Double) async {
        do {
            async let current = try await weatherService.getCurrentWeather(lat: lat, lon: lon)
            async let forcast = try await weatherService.getWeatherForcast(lat: lat, lon: lon)
            state = .success(currentWeather: try await current, weatherForcast: try await forcast)
        } catch {
            print(error)
            state = .failure(message: error.localizedDescription)
        }
        
    }
}


enum WeatherScreenState {
    case loading
    case failure(message: String)
    case success(currentWeather: CurrentWeather, weatherForcast: WeatherForcast)
}
