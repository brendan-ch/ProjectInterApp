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
    case SystemSelectionSetup
}

struct WelcomeContentView: View {
    @State private var path = NavigationPath()
    
    @EnvironmentObject var setupStateModel: SetupStateModel
    
    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView(onContinue: {
                path.append(WelcomeFlowView.LocationPermissionsRequestView)
            })
            .navigationDestination(for: WelcomeFlowView.self) { value in
                switch value {
                case WelcomeFlowView.LocationPermissionsRequestView:
                    LocationPermissionsRequestView {
                        path.append(WelcomeFlowView.NotificationPermissionsRequestView)
                    }
                    .navigationBarBackButtonHidden(true)
                case WelcomeFlowView.NotificationPermissionsRequestView:
                    NotificationPermissionsRequestView {
                        path.append(WelcomeFlowView.SystemSelectionSetup)
                    }
                    .navigationBarBackButtonHidden(true)
                case WelcomeFlowView.SystemSelectionSetup:
                    SystemSelectionSetupView {
                        setupStateModel.completeSetup()
                    }
                    .navigationBarBackButtonHidden(true)
                }
                
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WelcomeContentView()
        .environmentObject(SetupStateModel())
}
