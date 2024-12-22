//
//  WeatherController.swift
//  Weathery
//
//  Created by Mohammad Eid on 16/12/2024.
//

import SwiftUI
import CoreLocation

@Observable
class WeatherController: NSObject, CLLocationManagerDelegate {
    let weatherService: WeatherService
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D? {
        didSet {
            guard let location = currentLocation else { return }
            Task {
                currentWeatherData = try? await weatherService.getCurrentWeather(
                    lat: location.latitude,
                    lon: location.longitude
                )
            }
        }
    }
    
    var currentWeatherData: CurrentWeatherRsponse?
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
    }
}
