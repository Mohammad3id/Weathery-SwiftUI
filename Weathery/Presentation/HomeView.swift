//
//  HomeView.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//

import SwiftUI

struct HomeView: View {
    @State var weatherController = WeatherController()
    
    var body: some View {
        NavigationStack {
            WeatherLoaderView(weatherController) { weather in
                ScrollView {
                    VStack(spacing: 16) {
                        MainWeatherCard(weather: weather.current)
                        HourlyForecastCard(snapshots: weather.nextHours)
                        DailyForecastCard(snapshots: weather.nextDays)
                    }
                    .padding()
                }
            }
            .modifier(SoftBackgroundModifier())
            .navigationTitle("My location")
        }
        
    }
}

#Preview {
    HomeView()
}
