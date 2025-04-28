//
//  ApolloClientHolderSingleton.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.28.
//

import Apollo
import Foundation

class ApolloClientHolderSingleton {
    static let shared = ApolloClientHolderSingleton()
    
    let apolloClient: ApolloClientProtocol
    
    private init() {
        apolloClient = ApolloClient(url: URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)!)
    }
}

