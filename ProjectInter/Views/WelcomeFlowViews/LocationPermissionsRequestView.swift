//
//  LocationPermissionsRequestView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

struct LocationPermissionsRequestView: View {
    @EnvironmentObject var locationDataModel: GlobalLocationDataModel
    
    var onContinue: () -> Void
    
    var body: some View {
        Text("Enable location access")
        Text("Turn on location access to find your nearest stop.")
        
        Button {
            locationDataModel.requestAuthorization()
        } label: {
            Spacer()
            
            Text("Enable location access")
            
            Spacer()
        }
        .onChange(of: locationDataModel.authorizationStatus) {
            onContinue()
        }
        
        Button {
            onContinue()
        } label: {
            Text("Skip")
        }
    }
}

#Preview {
    LocationPermissionsRequestView {
        print("Continue pressed")
    }
    .environmentObject(GlobalLocationDataModel())
}
