//
//  WeatherLoaderView.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

import SwiftUI

struct WeatherLoaderView<Content: View>: View {
    private var weatherController: WeatherController
    
    @ViewBuilder let content: (_ weather: WeatherReport) -> Content
    
    init(_ weatherController: WeatherController, @ViewBuilder content: @escaping (_ weather: WeatherReport) -> Content) {
        self.weatherController = weatherController
        self.content = content
    }
    
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
        }.task {
            await weatherController.loadWeatherForCurrentLocation()
        }
    }
}

#Preview {
    WeatherLoaderView(WeatherController()) { weather in
        Text("Hello, World!")
    }
    .modifier(SoftBackgroundModifier())
}
