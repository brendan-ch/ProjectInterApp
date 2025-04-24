//
//  AppUpdateMessageView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.23.
//

import SwiftUI

struct AppUpdateMessageView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            Text("Unable to connect to server")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("The server may be restarting or temporarily unavailable. If this issue persists, make sure you're using the latest version of the app.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Text("Retry")
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
    AppUpdateMessageView()
}

