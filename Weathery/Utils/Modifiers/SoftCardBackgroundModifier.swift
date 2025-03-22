//
//  SoftCardBackgroundModifier.swift
//  Weathery
//
//  Created by Mohammad Eid on 22/12/2024.
//

import SwiftUICore
import UIKit

struct SoftCardBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if colorScheme == .dark {
            content
                .background(Color(UIColor.secondarySystemBackground))
        } else {
            content.background()
        }
    }
    
}
