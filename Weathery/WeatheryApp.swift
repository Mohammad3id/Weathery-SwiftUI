//
//  WeatheryApp.swift
//  Weathery
//
//  Created by Mohammad Eid on 15/12/2024.
//

import SwiftUI

@main
struct WeatheryApp: App {
    @State var locationsController = LocationsController()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(locationsController)
        }
    }
}
