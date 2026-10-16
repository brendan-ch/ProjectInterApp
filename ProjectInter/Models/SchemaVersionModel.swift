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
import ProjectInterLogging

struct SchemaVersionModelNetworkArguments {

}

@Observable
class SchemaVersionModel: NetworkDataModel<GetSchemaVersionQuery> {
    private(set) var compatibilityCheckCompleted = false
    private(set) var serverMinSchemaVersion: Int?
    private(set) var serverCurrentSchemaVersion: Int?

    var appSchemaVersion: Int?

    var isCompatible: Bool {
        if let appSchemaVersion = appSchemaVersion,
           let serverMinSchemaVersion = serverMinSchemaVersion,
           let serverCurrentSchemaVersion = serverCurrentSchemaVersion {
            return appSchemaVersion >= serverMinSchemaVersion && appSchemaVersion <= serverCurrentSchemaVersion
        }
        return false
    }

    init(appSchemaVersion: Int?) {
        self.appSchemaVersion = appSchemaVersion
    }

    required init() {
        self.appSchemaVersion = nil
    }

    static func convertNetworkArgumentsIntoQuery(_ arguments: SchemaVersionModelNetworkArguments) -> GetSchemaVersionQuery {
        return GetSchemaVersionQuery()
    }

    @MainActor
    override func processRefreshDataResult(_ result: Result<GetSchemaVersionQuery.Data, any Error>) {
        switch result {
        case .failure(let error):
            Loggers.shared.networkingLogger.error("Error fetching schema versions: \(error)")
        case .success(let result):
            self.serverMinSchemaVersion = result.schemaMinVersion
            self.serverCurrentSchemaVersion = result.schemaCurrentVersion
        }

        self.compatibilityCheckCompleted = true
    }
}
