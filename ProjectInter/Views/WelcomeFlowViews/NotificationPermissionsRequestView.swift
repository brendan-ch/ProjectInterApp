//
//  NotificationPermissionsRequestView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

struct NotificationPermissionsRequestView: View {
    @EnvironmentObject var customAppDelegate: CustomAppDelegate
    
    var onContinue: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer()
            Text("Enable notifications")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Turn on notifications to get notified when a shuttle arrives.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                Task {
                    await customAppDelegate.requestNotificationAuthorizationAndRegisterIfGranted()
                    
                    onContinue()
                }
            } label: {
                Spacer()
                
                Text("Enable notifications")
                    .bold()
                
                Spacer()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Button {
                onContinue()
            } label: {
                Text("Skip")
            }
        }
        .padding()
    }
}

#Preview {
    NotificationPermissionsRequestView {
        print("Continue pressed")
    }
    .environmentObject(CustomAppDelegate())
}
