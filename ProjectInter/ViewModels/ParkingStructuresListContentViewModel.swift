//
//  ParkingStructuresListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import Foundation

struct ParkingStructure {
    var address: String
    var spotsAvailable: Int
    var capacity: Int
    var coordinates: RawCoordinates
    var name: String
}

struct ParkingStructuresNetworkingArguments {
}

class ParkingStructuresListContentViewModel: NetworkDataModelProtocol {
    @Published var structures: [ParkingStructure] = []
    
    typealias T = ParkingStructuresNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    func refreshDataOnce(arguments: ParkingStructuresNetworkingArguments) async {
        // TODO: Implement this method
    }
}
