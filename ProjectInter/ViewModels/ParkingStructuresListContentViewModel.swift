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

class ParkingStructuresListContentViewModel: NetworkDataModelProtocol {
    @Published var structures: [ParkingStructuresListParkingStructure] = []
    @Published var structuresSupportedBySystem = false
    
    @Published var dataInitState: InitializationState = .notInitialized
    
    typealias NetworkArguments = ParkingStructuresNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloClient: ApolloClientProtocol?
    
    required init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: ParkingStructuresNetworkingArguments) -> GetParkingStructuresListDataQuery {
        return GetParkingStructuresListDataQuery(systemId: arguments.systemId)
    }
    
    func processRefreshDataResult(_ result: Result<GraphQLResult<GetParkingStructuresListDataQuery.Data>, any Error>) {
        switch result {
        case .failure(let error):
            print("Error fetching parking structures list data: \(error)")
        case .success(let result):
            guard let parkingSystem = result.data?.system?.parkingSystem else {
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
}
