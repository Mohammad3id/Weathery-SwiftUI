//
//  LocationsView.swift
//  Weathery
//
//  Created by Mohammad Eid on 24/12/2024.
//

import SwiftUI

struct LocationsView: View {
    @Environment(LocationsController.self) var locationsController
    
    let locations = [
        LocationsController.Location(label: "Label1", latitude: 1, longitude: 1),
        LocationsController.Location(label: "Label2", latitude: 2, longitude: 2),
        LocationsController.Location(label: "Label3", latitude: 3, longitude: 3),
    ]
    
    var body: some View {
        @Bindable var locationsController = locationsController
        
        List {
            LocationListItem(
                label: "Current location",
                isSelected: locationsController.selectedLocationIndex == nil
            ) {
                locationsController.selectedLocationIndex = nil
            }
            
            ForEach(Array(locationsController.locations.enumerated()), id: \.element) { index, location in
                LocationListItem(
                    label: location.label,
                    isSelected: locationsController.selectedLocationIndex == index
                ) {
                    locationsController.selectedLocationIndex = index
                }
            }.onDelete { indexSet in
                if let index = indexSet.first {
                    locationsController.delete(locationIndex: index)
                }
            }
        }
        .foregroundStyle(.foreground)
        .navigationTitle("Locations")
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    MapView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct LocationListItem: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void
    
//    @Environment(LocationsController.self) var locationsController
//    var index: Int?
    
    var body: some View {
//        let location = index == nil ? nil : locationsController.locations[index!]
        
        Button {
            onTap()
        } label: {
            HStack {
                Text(label)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                }
            }
        }
        .foregroundStyle(.foreground)
    }
}

#Preview {
    NavigationStack {
        LocationsView()
    }
    .environment(LocationsController())
}
