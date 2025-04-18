//
//  ParkingStructuresListContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import SwiftUI

struct ParkingStructuresListContentView: View {
    @StateObject var viewModel = ParkingStructuresListContentViewModel()
    
    @EnvironmentObject var globalDataModel: GlobalDataModel
    
    var networkArguments: ParkingStructuresNetworkingArguments? {
        if let systemId = globalDataModel.selectedSystem?.id {
            return .init(systemId: systemId)
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text("Structures")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
            
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            
            ScrollView {
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
        }
        .onAppear {
            if let apolloClient = globalDataModel.apolloClient {
                viewModel.apolloClient = apolloClient
            }
            
            if let networkArguments = networkArguments {
                viewModel.startRefreshingData(arguments: networkArguments)
            }
        }
        .onDisappear {
            viewModel.stopRefreshingData()
        }
    }
}

#Preview {
    let builder = ParkingStructuresListContentViewModelPlaceholderBuilder()
    let viewModel = builder.build()
    
    ParkingStructuresListContentView(viewModel: viewModel)
        .environmentObject(GlobalDataModel())
}
