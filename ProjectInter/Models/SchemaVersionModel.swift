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
    
    @Published var isCompatible = true
    
    func refreshDataOnce(arguments: SchemaVersionModelNetworkArguments) async {
    }
    
}
