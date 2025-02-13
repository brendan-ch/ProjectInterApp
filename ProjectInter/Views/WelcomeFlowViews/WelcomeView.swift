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
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            Text("Welcome to Interchange")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("View routes, shuttle locations, and estimated times for college transit.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                onContinue()
            }) {
                HStack {
                    Spacer()
                    Text("Continue")
                        .bold()
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    WelcomeView {
        print("Continue button clicked")
    }
}
