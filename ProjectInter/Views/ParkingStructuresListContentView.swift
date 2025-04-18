//
//  ParkingStructuresListContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import SwiftUI

struct ParkingStructuresListContentView: View {
    @StateObject var viewModel = ParkingStructuresListContentViewModel()
    
    var body: some View {
        Text("Parking structures")
    }
}

#Preview {
    let builder = ParkingStructuresListContentViewModelPlaceholderBuilder()
    let viewModel = builder.build()
    
    ParkingStructuresListContentView(viewModel: viewModel)
}
