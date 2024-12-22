//
//  AppScreenView.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

import SwiftUI

struct AppScreenView<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.cyan, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            content
                .padding()
        }
    }
}

#Preview {
    AppScreenView {
        Text("Hello, World!")
    }
}
