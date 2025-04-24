//
//  SchemaVersionModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.23.
//

import Foundation
import Apollo
import ApolloAPI

struct SchemaVersionModelNetworkArguments {
    
}

class SchemaVersionModel: NetworkDataModelProtocol {
    typealias T = SchemaVersionModelNetworkArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloClient: (any ApolloClientProtocol)?
     
    private(set )var serverMinSchemaVersion: Int?
    private(set) var serverCurrentSchemaVersion: Int?
    
    var appSchemaVersion: Int?
    
    @Published var isCompatible = true
    
    required init(apolloClient: (any Apollo.ApolloClientProtocol)?) {
        self.apolloClient = apolloClient
    }
    
    convenience init(apolloClient: (any Apollo.ApolloClientProtocol)?, appSchemaVersion: Int) {
        self.init(apolloClient: apolloClient)
    }

    func refreshDataOnce(arguments: SchemaVersionModelNetworkArguments) async {
        
    }
}
