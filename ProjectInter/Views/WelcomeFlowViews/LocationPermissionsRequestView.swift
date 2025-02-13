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
        VStack(alignment: .center, spacing: 8) {
            Spacer()
            
            Text("Enable location access")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Turn on location access to find your nearest stop.")
                .multilineTextAlignment(.center)

            Spacer()
            
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
    LocationPermissionsRequestView {
        print("Continue pressed")
    }
    .environmentObject(GlobalLocationDataModel())
}
