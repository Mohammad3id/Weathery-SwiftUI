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
            LocationListItem()
            
            ForEach(locationsController.locations.indices, id: \.self) { index in
                LocationListItem(index: index)
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
    @Environment(LocationsController.self) var locationsController
    var index: Int?
    
    var body: some View {
        let location = index == nil ? nil : locationsController.locations[index!]
        
        Button {
            locationsController.selectedLocationIndex = index
        } label: {
            HStack {
                Text(location?.label ?? "Current location")
                Spacer()
                if index == locationsController.selectedLocationIndex {
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
