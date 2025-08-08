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
    
    var apolloClient: (any ApolloClientProtocol)?
    
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
    
    required init(apolloClient: (any Apollo.ApolloClientProtocol)?) {
        self.apolloClient = apolloClient
    }
    
    convenience init(apolloClient: (any Apollo.ApolloClientProtocol)?, appSchemaVersion: Int?) {
        self.init(apolloClient: apolloClient)
        self.appSchemaVersion = appSchemaVersion
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: SchemaVersionModelNetworkArguments) -> GetSchemaVersionQuery {
        return GetSchemaVersionQuery()
    }
    
    func processRefreshDataResult(_ result: Result<GraphQLResult<GetSchemaVersionQuery.Data>, any Error>) {
        switch result {
        case .failure(let error):
            print("Error fetching schema versions: \(error)")
        case .success(let result):
            self.serverMinSchemaVersion = result.data?.schemaMinVersion
            self.serverCurrentSchemaVersion = result.data?.schemaCurrentVersion
        }
        
        self.compatibilityCheckCompleted = true
    }

    func refreshDataOnce(arguments: SchemaVersionModelNetworkArguments) async {
        guard let apolloClient = apolloClient else {
            return
        }
        
        return await withCheckedContinuation { continuation in
            var continuationIsActive = true
            apolloClient.fetch(query: GetSchemaVersionQuery()) { [weak self] result in
                if !continuationIsActive {
                    return
                }
                
                self?.processRefreshDataResult(result)
                
                continuationIsActive = false
                continuation.resume()
            }
        }
    }
}
