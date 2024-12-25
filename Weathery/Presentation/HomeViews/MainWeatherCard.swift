//
//  MainWeatherCard.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

import SwiftUI

struct MainWeatherCard: View {
    let weather: WeatherSnapshot
    let location: WeatherReport.Location
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey(weather.condition.rawValue))
                        .font(.system(size: 32, weight: .bold))
                }
                Spacer()
                Image(systemName: weather.condition.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            
            if let city = location.city, let country = location.country {
                Label("\(city), \(country)", systemImage: "mappin.and.ellipse")
            }
            
            Spacer()
                .frame(height: 18)
        
            HStack {
                HStack(alignment: .top, spacing: 0) {
                    Text("\(weather.temperature.actual, format: .number.precision(.fractionLength(1)))")
                        .font(.system(size: 32, weight: .bold))
                    Text("°C")
                        .padding(.top, 2)
                }
                .environment(\.layoutDirection, .leftToRight)
                
                Spacer()
                
                Label("\(weather.humidity)%", systemImage: "humidity")
                
                Spacer()
                
                Label("\(weather.wind.speed.formatted()) m/s", systemImage: "wind")
            }
        }
        .padding(24)
        .background(UIConstants.DirectionalBlueGradiant())
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    MainWeatherCard(weather: .mock, location: .mock)
        .padding()
}
