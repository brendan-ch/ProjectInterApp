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
    
    typealias T = ParkingStructuresNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloClient: ApolloClientProtocol?
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshDataOnce(arguments: ParkingStructuresNetworkingArguments) async {
        guard let apolloClient = apolloClient else { return }
        
        return await withCheckedContinuation { continuation in
            var continuationIsActive = true
            apolloClient.fetch(
                query: GetParkingStructuresListDataQuery(systemId: arguments.systemId)
            ) { result in
                if !continuationIsActive {
                    return
                }
                
                switch result {
                case .failure(let error):
                    // TODO: migrate to Logger instead of print
                    // https://www.reddit.com/r/Xcode/comments/1862x8h/remove_warnings_and_runtime_issues_from_xc15/
                    print("Error fetching parking structures list data: \(error)")
                case .success(let result):
                    guard let parkingSystem = result.data?.system?.parkingSystem else {
                        self.structuresSupportedBySystem = false
                        
                        continuationIsActive = false
                        continuation.resume()
                        
                        return
                    }
                    
                    self.structuresSupportedBySystem = true
                    if let structures = parkingSystem.parkingStructures {
                        self.structures = structures.map(ParkingStructuresListParkingStructure.init)
                    } else {
                        self.structures = []
                    }
                }
                
                continuationIsActive = false
                continuation.resume()
            }
        }
    }
}
