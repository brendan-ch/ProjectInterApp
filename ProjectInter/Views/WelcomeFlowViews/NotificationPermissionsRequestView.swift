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
        Text("Enable notifications")
        Text("Turn on notifications to get notified when a shuttle arrives.")
        
        Button {
            Task {
                await customAppDelegate.requestNotificationAuthorizationAndRegisterIfGranted()
                
                onContinue()
            }
        } label: {
            Spacer()
            
            Text("Enable notifications")
            
            Spacer()
        }
        
        Button {
            onContinue()
        } label: {
            Text("Skip")
        }
    }
}

#Preview {
    NotificationPermissionsRequestView {
        print("Continue pressed")
    }
    .environmentObject(CustomAppDelegate())
}
