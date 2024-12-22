//
//  UIConstants.swift
//  Weathery
//
//  Created by Mohammad Eid on 22/12/2024.
//

import SwiftUI

struct UIConstants {
    struct DirectionalBlueGradiant: ShapeStyle {
        func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
            LinearGradient(
                colors: [.appBlue, .appBlueLight],
                startPoint: environment.layoutDirection == .leftToRight ? .leading : .trailing,
                endPoint: environment.layoutDirection == .leftToRight ? .trailing : .leading
            )
        }
    }
}


