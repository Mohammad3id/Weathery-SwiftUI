//
//  WeatherLoaderView.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

import SwiftUI

struct WeatherLoaderView<Content: View>: View {
    @State var weatherController = WeatherController()
    @Environment(LocationsController.self) var locationsController
    
    @ViewBuilder let content: (_ weather: WeatherReport) -> Content
    
    
    var body: some View {
        Group {
            switch weatherController.state {
            case .loading:
                ProgressView("Loading")
            case .failure(let message):
                Text(message)
            case .success(let weatherReport):
                content(weatherReport)
            }
        }.onChange(of: locationsController.selectedLocation, initial: true) { oldValue, newValue in
            Task {
                if let selectedLocation = newValue {
                    await weatherController.loadWeatherForLocation(
                        latitude: selectedLocation.latitude,
                        longitude: selectedLocation.longitude
                    )
                } else {
                    await weatherController.loadWeatherForCurrentLocation()
                }
            }
        }
    }
}

#Preview {
    WeatherLoaderView { weather in
        Text("Hello, World!")
    }
    .modifier(SoftBackgroundModifier())
    .environment(LocationsController())
}
