//
//  ParkingStructuresListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import Foundation
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

class ParkingStructuresListContentViewModel: NetworkDataModelProtocol {
    @Published var structures: [ParkingStructuresListParkingStructure] = []
    
    typealias T = ParkingStructuresNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    func refreshDataOnce(arguments: ParkingStructuresNetworkingArguments) async {
        // TODO: Implement this method
    }
}
