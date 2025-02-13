//
//  WelcomeContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

enum WelcomeFlowView {
    case LocationPermissionsRequestView
    case NotificationPermissionsRequestView
}

struct WelcomeContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView(onContinue: {
                path.append(WelcomeFlowView.LocationPermissionsRequestView)
            })
            .navigationDestination(for: WelcomeFlowView.self) { value in
                switch value {
                case WelcomeFlowView.LocationPermissionsRequestView:
                    LocationPermissionsRequestView()
                case WelcomeFlowView.NotificationPermissionsRequestView:
                    NotificationPermissionsRequestView {
                    }
                }
                
            }
        }
    }
}

#Preview {
    WelcomeContentView()
}
