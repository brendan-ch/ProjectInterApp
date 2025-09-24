//
//  ParkingStructuresListContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import SwiftUI

struct ParkingStructuresListContentView: NetworkView {
    typealias NetworkArguments = ParkingStructuresNetworkingArguments
    typealias ViewModelType = ViewModel
    
    @State var viewModel = ViewModel()
    
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionModel: GlobalIdSelectionModel

    var networkArguments: ParkingStructuresNetworkingArguments? {
        if let systemId = globalSystemsModel.selectedSystem?.id {
            return .init(systemId: systemId)
        }
        return nil
    }
    
    var body: some View {
        HeadingWrapperView(title: "Structures") {
            WithInitializationView(dataInitState: viewModel.dataInitState) {
                if !viewModel.structuresSupportedBySystem {
                    Spacer()
                    Text("Parking data is not supported for this system.")
                        .padding()
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    DataWrapperView(shouldDisplayNoDataMessage: viewModel.structures.isEmpty, noDataMessage: "No parking structures available.") {
                        ForEach(viewModel.structures) { structure in
                            ParkingStructureItem(structure: structure) { structure in
                                globalIdSelectionModel.selectParkingStructureId(structure.id)
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))

        }
        .onAppear {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
    }
}

struct ParkingStructureItem: View {
    let structure: ParkingStructuresListParkingStructure
    let action: (_ selectedParkingStructure: ParkingStructuresListParkingStructure) -> Void

    var currentCount: Int {
        structure.capacity - structure.spotsAvailable
    }
    var body: some View {
        Button {
            action(structure)
        } label: {
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
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    let viewModel = ParkingStructuresListContentView.ViewModel.buildPlaceholder()
    viewModel.structuresSupportedBySystem = true
    viewModel.structures = [
        .init(spotsAvailable: 50, capacity: 100, name: "Anderson", id: "1"),
        .init(spotsAvailable: 50, capacity: 200, name: "Barrera", id: "2")
    ]
    
    return ParkingStructuresListContentView(viewModel: viewModel)
        .environment(GlobalSystemsModel.buildPlaceholder())
        .environment(GlobalIdSelectionModel())
}
