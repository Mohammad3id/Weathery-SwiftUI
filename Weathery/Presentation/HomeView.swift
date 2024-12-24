//
//  HomeView.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(LocationsController.self) var locationsController
    
    var body: some View {
        NavigationStack {
            WeatherLoaderView { weather in
                ScrollView {
                    VStack(spacing: 16) {
                        MainWeatherCard(weather: weather.info.current, location: weather.location)
                        HourlyForecastCard(snapshots: weather.info.nextHours)
                        DailyForecastCard(snapshots: weather.info.nextDays)
                    }
                    .padding()
                }
            }
            .modifier(SoftBackgroundModifier())
            .navigationTitle(locationsController.selectedLocation?.label ?? "My location")
            .toolbar {
                ToolbarItem {
                    NavigationLink("Locations") {
                        LocationsView()
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
