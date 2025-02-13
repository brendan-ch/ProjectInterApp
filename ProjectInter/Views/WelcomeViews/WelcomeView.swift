//
//  WelcomeView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

struct WelcomeView: View {
    var onContinue: () -> Void
    
    var body: some View {
        Text("Welcome to Interchange")
        Text("View routes, shuttle locations, and estimated times for college transit.")
        Button {
            onContinue()
        } label: {
            Text("Continue")
        }
    }
}

#Preview {
    WelcomeView {
        print("Continue button clicked")
    }
}
