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
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            
            Image(systemName: "bell.badge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 56)
            
            Text("Turn on notifications")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Turn on notifications to get notified when a shuttle arrives. You may change this later in Settings.")
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
