//
//  SoftBackgroundModifier.swift
//  Weathery
//
//  Created by Mohammad Eid on 22/12/2024.
//

import SwiftUICore
import UIKit

struct SoftBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        ZStack {
            if colorScheme == .light {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
            }        
            content
        }
    }
    
}
