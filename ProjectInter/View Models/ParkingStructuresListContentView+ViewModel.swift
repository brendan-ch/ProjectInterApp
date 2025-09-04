//
//  ParkingStructuresListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import Foundation
import Apollo
import ProjectInterOperations

// MARK: - Models

struct ParkingStructuresListParkingStructure: Identifiable {
    var spotsAvailable: Int
    var capacity: Int
    var name: String
    var id: String
}

extension ParkingStructuresListParkingStructure {
    init(_ parkingStructure: GetParkingStructuresListDataQuery.Data.System.ParkingSystem.ParkingStructure) {
        id = parkingStructure.id
        name = parkingStructure.name
        capacity = parkingStructure.capacity
        spotsAvailable = parkingStructure.spotsAvailable
    }
}

// MARK: - Network arguments

struct ParkingStructuresNetworkingArguments {
    let systemId: String
}

// MARK: - View model implementation

extension ParkingStructuresListContentView {
    @Observable
    class ViewModel: NetworkDataModel<ParkingStructuresNetworkingArguments, GetParkingStructuresListDataQuery>, PlaceholderBuildable {
        var structures: [ParkingStructuresListParkingStructure] = []
        var structuresSupportedBySystem = false
        
        func convertNetworkArgumentsIntoQuery(_ arguments: ParkingStructuresNetworkingArguments) -> GetParkingStructuresListDataQuery {
            return GetParkingStructuresListDataQuery(systemId: arguments.systemId)
        }
        
        func processRefreshDataResult(_ result: Result<GetParkingStructuresListDataQuery.Data, any Error>) {
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
                    self.structures = structures.map(ParkingStructuresListParkingStructure.init)
                } else {
                    self.structures = []
                }
            }
        }
        
        static func buildPlaceholder() -> Self {
            let viewModel = Self(dataInitState: .succeeded)
            viewModel.structures = [
                .init(
                    spotsAvailable: 680,
                    capacity: 871,
                    name: "Anderson Structure",
                    id: "1"
                ),
                .init(
                    spotsAvailable: 425,
                    capacity: 692,
                    name: "Barrera",
                    id: "2"
                )
            ]
            
            return viewModel
        }
    }
}
