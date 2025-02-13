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
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            
            Image(systemName: "location")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 56)

            Text("Turn on location access")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Turn on location access to find your nearest stop. You may change this later in Settings.")
                .multilineTextAlignment(.center)

            Spacer()
            
            Button {
                locationDataModel.requestAuthorization()
            } label: {
                Spacer()
                
                Text("Enable location access")
                    .bold()
                
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
