//
//  HourlyForecastCard.swift
//  Weathery
//
//  Created by Mohammad Eid on 22/12/2024.
//

import SwiftUI

struct HourlyForecastCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    let snapshots: [WeatherSnapshot]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(snapshots.first!.date.formatted(date: .long, time: .omitted))
                .bold()
                .font(.system(size: 24))
                .foregroundStyle(UIConstants.DirectionalBlueGradiant())
            Spacer()
                .frame(height: 30)
            HStack() {
                ForEach(snapshots, id: \.date) { snapshot in
                    HourlyForecastSnapshotView(snapshot: snapshot)
                    if (snapshot.date != snapshots.last?.date) {
                        Spacer()
                    }
                }
            }
        }
        .padding(24)
        .modifier(SoftCardBackgroundModifier())
        .clipShape(.rect(cornerRadius: 20))
    }
    
}

fileprivate struct HourlyForecastSnapshotView: View {
    let snapshot: WeatherSnapshot
    
    var body: some View {
        VStack {
            Text(snapshot.date.formatted(.dateTime.hour()))
                .foregroundStyle(.gray)
            Image(systemName: snapshot.condition.image)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.vertical, 5)
                .shadow(radius: 1)
            Text("\(snapshot.temperature.actual.rounded().formatted())°C")
        }
    }
}


#Preview {
    HourlyForecastCard(
        snapshots: WeatherSnapshot.mockList
    )
    .padding()
    .modifier(SoftBackgroundModifier())
}
