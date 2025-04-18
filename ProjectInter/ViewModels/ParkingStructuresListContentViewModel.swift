//
//  ParkingStructuresListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import Foundation

struct ParkingStructuresListParkingStructure: Identifiable {
    var spotsAvailable: Int
    var capacity: Int
    var name: String
    var id: String
}

struct ParkingStructuresNetworkingArguments {
    let systemId: String
}

class ParkingStructuresListContentViewModel: NetworkDataModelProtocol {
    @Published var structures: [ParkingStructuresListParkingStructure] = []
    
    typealias T = ParkingStructuresNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    func refreshDataOnce(arguments: ParkingStructuresNetworkingArguments) async {
        // TODO: Implement this method
    }
}
