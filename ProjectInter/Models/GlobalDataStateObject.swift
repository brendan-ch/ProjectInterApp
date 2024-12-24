//
//  NetworkStateObject.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ApolloAPI
import ProjectInterOperations

class GlobalDataStateObject: ObservableObject {
    var apolloClient: ApolloClient
    
    @Published private(set) var systems: [GetAllSystemsQuery.Data.System] = []
    @Published var selectedSystem: GetAllSystemsQuery.Data.System? = nil
    
    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
    
    func refreshSystemData() {
        apolloClient.fetch(query: GetAllSystemsQuery()) { result in
            guard let data = try? result.get().data else { return }
            self.systems = data.systems
        }
    }
}
