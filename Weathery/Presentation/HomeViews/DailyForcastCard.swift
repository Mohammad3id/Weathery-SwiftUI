//
//  DailyForecastCard.swift
//  Weathery
//
//  Created by Mohammad Eid on 22/12/2024.
//

import SwiftUI

struct DailyForecastCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    let snapshots: [WeatherSnapshot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Forecast")
                .font(.system(size: 24))
                .foregroundStyle(UIConstants.DirectionalBlueGradiant())
            ForEach(snapshots, id: \.date) { snapshot in
                DailyForecastSnapshotView(snapshot: snapshot)
            }
        }
        .padding(24)
        .modifier(SoftCardBackgroundModifier())
        .clipShape(.rect(cornerRadius: 20))
    }
    
}

fileprivate struct DailyForecastSnapshotView: View {
    let snapshot: WeatherSnapshot
    
    var body: some View {
        HStack {
            Image(systemName: snapshot.condition.image)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.vertical, 5)
                .shadow(radius: 2)
            Spacer()
                .frame(width: 32)
            Text(snapshot.date.formatted(.dateTime.weekday(.wide)))
            Spacer()
            Text("\(snapshot.temperature.actual.rounded().formatted())°")
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    DailyForecastCard(
        snapshots: WeatherSnapshot.mockList
    )
    .padding()
    .modifier(SoftBackgroundModifier())
}
