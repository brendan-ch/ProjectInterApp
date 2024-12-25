//
//  NetworkStateObject.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ApolloAPI
import ApolloTestSupport
import ProjectInterOperations
import ProjectInterTestMocks

protocol GlobalDataStateObjectProtocol: ObservableObject {
    associatedtype System
    var systems: [System] { get set }
    var selectedSystem: System? { get set }
    
    func refreshSystemData()
}

class GlobalDataStateObject: GlobalDataStateObjectProtocol {
    var apolloClient: ApolloClient
    
    @Published var systems: [System] = []
    @Published var selectedSystem: System? = nil
    
    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
    
    func refreshSystemData() {
        apolloClient.fetch(query: GetAllSystemsQuery()) { result in
            guard let data = try? result.get().data else { return }
            
            self.systems = data.systems.map { system in
                System(name: system.name, id: system.id)
            }
        }
    }
}

class PlaceholderGlobalDataStateObject: GlobalDataStateObjectProtocol {
    @Published var systems: [System] = []
    @Published var selectedSystem: System? = nil
    
    func refreshSystemData() {
        systems = [
            System(name: "Chapman University", id: "1"),
            System(name: "City of Monterey Park", id: "2")
        ]
    }
}
