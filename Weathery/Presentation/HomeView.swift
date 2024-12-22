//
//  ContentView.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//

import SwiftUI

struct HomeView: View {
    @State var weatherController = WeatherController(
        weatherService: WeatherService(),
        locationManager: LocationManager()
    )
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.cyan, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            switch weatherController.state {
            case .loading:
                ProgressView("Loading")
            case .failure(let message):
                Text(message)
            case .success(let currentWeather, _):
                Text(currentWeather.dt.description)
            }
        }
        .task {
            await weatherController.loadWeatherForCurrentLocation()
        }
    }
}

#Preview {
    HomeView()
}
