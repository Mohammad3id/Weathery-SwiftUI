//
//  SoftBackgroundModifier.swift
//  Weathery
//
//  Created by Mohammad Eid on 22/12/2024.
//

import SwiftUICore
import UIKit

struct SoftBackgroundModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            content
        }
    }
    
}
