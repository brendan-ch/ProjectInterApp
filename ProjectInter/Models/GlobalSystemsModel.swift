//
//  GlobalSystemsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

import Foundation
import Apollo
import ProjectInterOperations

// MARK: - Models

/// Represents a single system available from the server.
struct System: Equatable, Identifiable {
    var name: String
    var id: String
}


// MARK: - Network arguments

struct GlobalDataModelNetworkArguments {
    
}

class GlobalSystemsModel: NetworkDataModelProtocol {
    typealias T = GlobalDataModelNetworkArguments
    
    var apolloClient: ApolloClientProtocol?
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    @Published var systems: [System] = []
    @Published var selectedSystem: System? = nil

    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshDataOnce(arguments _: GlobalDataModelNetworkArguments) async {
        await refreshSystemData()
    }
    
    func refreshSystemData() async {
        return await withCheckedContinuation { continuation in
            guard let apolloClient = apolloClient else {
                continuation.resume()
                return
            }
            
            apolloClient.fetch(query: GetAllSystemsQuery()) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.systems = data.systems.map { system in
                            System(name: system.name, id: system.id)
                        }
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
                
                continuation.resume()
            }
        }
    }

}
