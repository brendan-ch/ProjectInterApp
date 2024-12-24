//
//  NetworkStateObject.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ApolloAPI

class GlobalDataStateObject: ObservableObject {
    var apolloClient: ApolloClient
    
    @Published private(set) var systems: [ProjectInterOperations.GetAllSystemsQuery.Data.System] = []
    @Published var selectedSystem: ProjectInterOperations.GetAllSystemsQuery.Data.System? = nil
    
    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
    
    func refreshSystemData() {
        apolloClient.fetch(query: ProjectInterOperations.GetAllSystemsQuery()) { result in
            guard let data = try? result.get().data else { return }
            self.systems = data.systems
        }
    }
}
