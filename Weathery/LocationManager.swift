//
//  WeatherController.swift
//  Weathery
//
//  Created by Mohammad Eid on 16/12/2024.
//

import SwiftUI
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(accuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer) async throws -> CLLocationCoordinate2D {
        locationManager.desiredAccuracy = accuracy
        return try await withCheckedThrowingContinuation { continuation in
            guard self.continuation == nil else {
                continuation.resume(throwing: LocationError.requestInProgress)
                return;
            }
            
            self.continuation = continuation
            
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
            default:
                continuation.resume(throwing: LocationError.permissionDenied)
                self.continuation = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            continuation?.resume(returning: location)
        } else {
            continuation?.resume(throwing: LocationError.noLocationFound)
        }
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            continuation?.resume(throwing: LocationError.permissionDenied)
            self.continuation = nil
        }
    }
}

enum LocationError: Error {
    case noLocationFound
    case permissionDenied
    case requestInProgress
}
