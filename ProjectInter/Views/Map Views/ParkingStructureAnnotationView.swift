//
//  ParkingStructureAnnotationView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

struct ParkingStructureAnnotationView: View {
    var structure: MapViewParkingStructure
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(.blue)
            RoundedRectangle(cornerRadius: 100)
                .stroke(.white, lineWidth: 4)
            Image(systemName: "parkingsign.circle")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(6)
                .foregroundStyle(Color.white)
        }
        .accessibilityLabel("Parking structure")
        .accessibilityValue(structure.id)
    }

}
