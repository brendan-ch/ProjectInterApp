//
//  SchemaVersionModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.23.
//

import Foundation
import Apollo
import ApolloAPI
import ProjectInterOperations

struct SchemaVersionModelNetworkArguments {
    
}

class SchemaVersionModel: NetworkDataModelProtocol {
    typealias T = SchemaVersionModelNetworkArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloNetworkModel: ApolloNetworkModel?
    
    @Published var dataInitState: InitializationState = .notInitialized
    
    @Published private(set) var compatibilityCheckCompleted = false
     
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
    
    required init(apolloNetworkModel: ApolloNetworkModel? = nil) {
        self.apolloNetworkModel = apolloNetworkModel
    }
    
    convenience init(apolloNetworkModel: ApolloNetworkModel? = nil, appSchemaVersion: Int?) {
        self.init(apolloNetworkModel: apolloNetworkModel)
        self.appSchemaVersion = appSchemaVersion
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: SchemaVersionModelNetworkArguments) -> GetSchemaVersionQuery {
        return GetSchemaVersionQuery()
    }
    
    func processRefreshDataResult(_ result: Result<GetSchemaVersionQuery.Data, any Error>) {
        switch result {
        case .failure(let error):
            print("Error fetching schema versions: \(error)")
        case .success(let result):
            self.serverMinSchemaVersion = result.schemaMinVersion
            self.serverCurrentSchemaVersion = result.schemaCurrentVersion
        }
        
        self.compatibilityCheckCompleted = true
    }
}
