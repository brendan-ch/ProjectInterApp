//
//  ParkingStructuresListContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import SwiftUI

struct ParkingStructuresListContentView: NetworkView {
    typealias NetworkArguments = ParkingStructuresNetworkingArguments
    typealias ViewModelType = ParkingStructuresListContentViewModel
    
    @StateObject var viewModel = ParkingStructuresListContentViewModel()
    
    @EnvironmentObject var globalSystemsModel: GlobalSystemsModel
    
    var networkArguments: ParkingStructuresNetworkingArguments? {
        if let systemId = globalSystemsModel.selectedSystem?.id {
            return .init(systemId: systemId)
        }
        return nil
    }
    
    var body: some View {
        RootSheetContentView(title: "Structures") {
            ForEach(viewModel.structures) { structure in
                let currentCount = structure.capacity - structure.spotsAvailable
                
                VStack(spacing: 8) {
                    VStack{
                        HStack {
                            Text(structure.name)
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("\(structure.spotsAvailable) available")
                            Spacer()
                            Text("\(currentCount)/\(structure.capacity)")
                        }
                    }
                    ProgressView(value: Double(currentCount) / Double(structure.capacity))
                        .progressViewStyle(LinearProgressViewStyle())
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                
                Divider()
            }
        }
        .onAppear {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
    }
}

#Preview {
    let builder = ParkingStructuresListContentViewModelPlaceholderBuilder()
    let viewModel = builder.build()
    
    ParkingStructuresListContentView(viewModel: viewModel)
        .environmentObject(GlobalSystemsModelPlaceholderBuilder().build())
}
