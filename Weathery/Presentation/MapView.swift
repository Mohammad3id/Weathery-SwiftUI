//
//  MapView.swift
//  Weathery
//
//  Created by Mohammad Eid on 24/12/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(LocationsController.self) var locationsController
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var selectedLocationName: String?
    
    var body: some View {
        MapReader { proxy in
            Map {
                if let selectedLocation {
                    Marker("", coordinate: selectedLocation)
                }
            }
            .onTapGesture { point in
                guard let location = proxy.convert(point, from: .local)  else { return }
                
                withAnimation {
                    selectedLocation = location
                }
            }
        }
        .overlay(alignment: .bottom) {
            if selectedLocation != nil {
                Group {
                    if selectedLocationName != nil  {
                        let locationNameBinding = Binding {
                            selectedLocationName!
                        } set: { name in
                            selectedLocationName = name
                        }

                        TextField("Location Name", text: locationNameBinding)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 30))
                    } else {
                        ProgressView("Loading")
                    }
                }
                .safeAreaPadding(.bottom)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.bar)
                .shadow(radius: 1)
                .transition(.move(edge: .bottom))
                .onChange(of: selectedLocation, initial: true) { _, newLocation in
                    guard let newLocation else { return }
                    
                    Task {
                        if let placemark = try? await LocationManager().getPlacemark(latitude: newLocation.latitude, longitude: newLocation.longitude),
                           let city = placemark.administrativeArea,
                           let country = placemark.country {
                            await MainActor.run {
                                withAnimation {
                                    selectedLocationName = "\(city), \(country)"
                                }
                            }
                        } else {
                            await MainActor.run {
                                withAnimation {
                                    selectedLocationName = "Unknown"
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Add location")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let selectedLocation, let selectedLocationName {
                ToolbarItem {
                    Button("Save") {
                        locationsController.add(
                            location: LocationsController.Location(
                                label: selectedLocationName,
                                latitude: selectedLocation.latitude,
                                longitude: selectedLocation.longitude
                            )
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

#Preview {
    NavigationStack {
        MapView()
    }
}
