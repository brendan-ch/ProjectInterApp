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
     
    @Published private(set) var serverMinSchemaVersion: Int?
    @Published private(set) var serverCurrentSchemaVersion: Int?
    
    @Published var appSchemaVersion: Int?
    
    var isCompatible: Bool {
        if let appSchemaVersion = appSchemaVersion,
           let serverMinSchemaVersion = serverMinSchemaVersion,
           let serverCurrentSchemaVersion = serverCurrentSchemaVersion {
            return appSchemaVersion >= serverMinSchemaVersion && appSchemaVersion <= serverCurrentSchemaVersion
        }
        return false
    }
    
    required init(apolloClient: (any Apollo.ApolloClientProtocol)?) {
        self.apolloClient = apolloClient
    }
    
    convenience init(apolloClient: (any Apollo.ApolloClientProtocol)?, appSchemaVersion: Int) {
        self.init(apolloClient: apolloClient)
    }

    func refreshDataOnce(arguments: SchemaVersionModelNetworkArguments) async {
        
    }
}
