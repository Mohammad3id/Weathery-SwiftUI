//
//  HomeView.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//

import SwiftUI

struct HomeView: View {
    @State var weatherController = WeatherController()
    
    @Environment(LocationsController.self) var locationsController
    
    var body: some View {
        NavigationStack {
            Group {
                switch weatherController.state {
                case .loading:
                    ProgressView("Loading")
                case .failure(let message):
                    Text(message)
                case .success(let weatherReport):
                    ScrollView {
                        VStack(spacing: 16) {
                            MainWeatherCard(weather: weatherReport.info.current, location: weatherReport.location)
                            HourlyForecastCard(snapshots: weatherReport.info.nextHours)
                            DailyForecastCard(snapshots: weatherReport.info.nextDays)
                        }
                        .padding()
                    }
                }
            }
            .modifier(SoftBackgroundModifier())
            .navigationTitle(LocalizedStringKey(locationsController.selectedLocation?.label ?? "My location"))
            .toolbar {
                ToolbarItem {
                    NavigationLink("Locations") {
                        LocationsView()
                    }
                }
            }
            .onChange(of: locationsController.selectedLocation, initial: true) { oldValue, newValue in
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
}

#Preview {
    HomeView()
        .environment(LocationsController())
}
