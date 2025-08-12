//
//  ApolloNetworkModelSingleton.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.12.
//

import Apollo

class ApolloNetworkModelSingleton {
    static let shared = ApolloNetworkModelSingleton()
    
    let apolloNetworkModel: ApolloNetworkModel
    
    private init() {
        let apolloClient = ApolloClient(url: .apiBaseUrl)
        apolloNetworkModel = ApolloNetworkModel(client: apolloClient)
    }
}
