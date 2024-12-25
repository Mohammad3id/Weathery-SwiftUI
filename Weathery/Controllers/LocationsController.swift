//
//  LocationsController.swift
//  Weathery
//
//  Created by Mohammad Eid on 24/12/2024.
//

import SwiftUI
import CoreLocation

@MainActor
@Observable
class LocationsController {
    private let locationsFile = try! FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: false
    ).appendingPathComponent("weathery_locations.data")
    private let selectedLocationKey = "selectedLocation"
    
    var locations: [Location] = []
    
    var selectedLocationIndex: Int? {
        didSet {
            saveSelectedLocationIndex()
        }
    }
    
    var selectedLocation: Location? {
        if let selectedLocationIndex {
            locations[selectedLocationIndex]
        } else {
            nil
        }
    }
    
    struct Location: Codable, Hashable {
        let label: String
        let latitude: Double
        let longitude: Double
    }
    
    init() {
        if !FileManager.default.fileExists(atPath: locationsFile.path()) { return }
        
        guard let locationsData = try? Data(contentsOf: locationsFile) else {
            print("Couldn't get data from locations data file")
            return
        }
        
        guard let decodedLocations = try? JSONDecoder().decode([Location].self, from: locationsData) else {
            print("Couldn't decode saved locations")
            return
        }
        
        locations = decodedLocations
        
        guard UserDefaults.standard.object(forKey: selectedLocationKey) != nil else { return }
        
        let decodedSelectedLocationIndex = UserDefaults.standard.integer(forKey: selectedLocationKey)
        
        if decodedSelectedLocationIndex < locations.count {
            selectedLocationIndex = decodedSelectedLocationIndex
        } else {
            UserDefaults.standard.removeObject(forKey: selectedLocationKey)
        }
    }
    
    func add(location: Location) {
        locations.append(location)
        do {
            try saveCurrentLocations()
        } catch {
            print("Could not save locations")
            print(error)
            locations.removeLast()
        }
    }
    
    func delete(locationIndex: Int) {
        let removedLocation = locations.remove(at: locationIndex)
        do {
            try saveCurrentLocations()
        } catch {
            print("Could not save locations")
            print(error)
            locations.insert(removedLocation, at: locationIndex)
            return
        }
        
        guard let selectedLocationIndex else { return }
        
        if selectedLocationIndex == locationIndex {
            self.selectedLocationIndex = nil
        } else if selectedLocationIndex > locationIndex {
            self.selectedLocationIndex! -= 1
        }
        
        saveSelectedLocationIndex()
    }
    
    private func saveCurrentLocations() throws {
        let encodedLocations = try JSONEncoder().encode(locations)
        try encodedLocations.write(to: locationsFile)
    }
    
    private func saveSelectedLocationIndex() {
        if let index = selectedLocationIndex {
            UserDefaults.standard.set(index, forKey: selectedLocationKey)
        } else {
            UserDefaults.standard.removeObject(forKey: selectedLocationKey)
        }
    }
}

