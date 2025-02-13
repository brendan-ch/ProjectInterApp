//
//  NotificationPermissionsRequestView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

struct NotificationPermissionsRequestView: View {
    var body: some View {
        Text("Enable notifications")
        Text("Turn on notifications to get notified when a shuttle arrives.")
        
        Button {
            
        } label: {
            Spacer()
            
            Text("Enable notifications")
            
            Spacer()
        }
        
        Button {
            
        } label: {
            Text("Skip")
        }
    }
}

#Preview {
    NotificationPermissionsRequestView()
}
