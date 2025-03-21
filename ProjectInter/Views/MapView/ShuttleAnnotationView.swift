//
//  ShuttleAnnotationView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.20.
//

import SwiftUI

struct ShuttleAnnotationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var shuttle: MapViewShuttle
    
    var shouldDisplayOrientation = false
    
    var shouldBeTransparent = false
    
    var mapHeading: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(hex: shuttle.routeColorHex ?? "#000000"))
            RoundedRectangle(cornerRadius: 100)
                .stroke(.white, lineWidth: 4)
            Image(systemName: "bus.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(6)
                .foregroundStyle(Color.white)
            
            if shouldDisplayOrientation {
                // Direction arrow
                Triangle()
                    .fill(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 6, height: 6)
                    .offset(y: -21)
                    .rotationEffect(.degrees(shuttle.orientationInDegrees - mapHeading))
            }
        }
        .opacity(shouldBeTransparent ? 0.5 : 1.0)
        .accessibilityLabel("Shuttle")
        .accessibilityValue(shuttle.id)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Tap to view info about this shuttle.")
    }
}
