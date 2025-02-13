//
//  LocationPermissionsRequestView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

struct LocationPermissionsRequestView: View {
    var onContinue: () -> Void
    
    var body: some View {
        Text("Enable location access")
        Text("Turn on location access to find your nearest stop.")
        
        Button {
            // Request permissions
            // Once completed, call onContinue
            
            onContinue()
        } label: {
            Spacer()
            
            Text("Enable location access")
            
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
    LocationPermissionsRequestView {
        print("Continue pressed")
    }
}
