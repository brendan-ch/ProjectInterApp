//
//  ParkingStructuresListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import Foundation
import Apollo
import ProjectInterOperations
import ProjectInterShared

// MARK: - Models
// This view model uses the shared ``ParkingStructure`` model.

extension ParkingStructure {
    init(_ parkingStructure: GetParkingStructuresListDataQuery.Data.System.ParkingSystem.ParkingStructure) {
        self = .init(
            id: parkingStructure.id,
            name: parkingStructure.name,
            capacity: parkingStructure.capacity,
            spotsAvailable: parkingStructure.spotsAvailable
        )
    }
}

// MARK: - Network arguments

struct ParkingStructuresNetworkingArguments {
    let systemId: String
}

// MARK: - View model implementation

extension ParkingStructuresListContentView {
    @Observable
    class ViewModel: NetworkDataModel<ParkingStructuresNetworkingArguments, GetParkingStructuresListDataQuery>, PlaceholderBuildable, Clearable {
        var structures: [ParkingStructure] = []
        var structuresSupportedBySystem = false
        
        override func convertNetworkArgumentsIntoQuery(_ arguments: ParkingStructuresNetworkingArguments) -> GetParkingStructuresListDataQuery {
            return GetParkingStructuresListDataQuery(systemId: arguments.systemId)
        }
        
        override func processRefreshDataResult(_ result: Result<GetParkingStructuresListDataQuery.Data, any Error>) {
            switch result {
            case .failure(let error):
                print("Error fetching parking structures list data: \(error)")
            case .success(let result):
                guard let parkingSystem = result.system?.parkingSystem else {
                    self.structuresSupportedBySystem = false
                    
                    return
                }
                
                self.structuresSupportedBySystem = true
                if let structures = parkingSystem.parkingStructures {
                    self.structures = structures.map(ParkingStructure.init)
                } else {
                    self.structures = []
                }
            }
        }
        
        func clearData() {
            resetDataInitState()
            structures = []
            structuresSupportedBySystem = false
        }
        
        static func buildPlaceholder() -> Self {
            let viewModel = Self(dataInitState: .succeeded)
            viewModel.structures = [
                .init(
                    id: "1",
                    name: "Anderson Structure",
                    capacity: 871,
                    spotsAvailable: 680,
                ),
                .init(
                    id: "2",
                    name: "Barrera",
                    capacity: 692,
                    spotsAvailable: 425,
                )
            ]
            
            return viewModel
        }
    }
}
