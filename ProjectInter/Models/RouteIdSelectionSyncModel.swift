//
//  IdSelectionSyncModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.23.
//

import Foundation
import Apollo
import ProjectInterOperations
import ProjectInterLogging

// TODO: Remove this

struct RouteIdSelectionSyncNetworkArguments {
    let systemId: String
    let shuttleId: String
}

@Observable
class RouteIdSelectionSyncModel: NetworkDataModel<GetRouteIdForShuttleQuery>, GraphQLQueryConstructable {
    private(set) var routeId: String? = nil

    required init() {}

    static func convertNetworkArgumentsIntoQuery(_ arguments: RouteIdSelectionSyncNetworkArguments) -> GetRouteIdForShuttleQuery {
        return GetRouteIdForShuttleQuery(systemId: arguments.systemId, shuttleId: arguments.shuttleId)
    }

    @MainActor
    override func processRefreshDataResult(_ result: Result<GetRouteIdForShuttleQuery.Data, any Error>) {
        switch result {
        case .success(let data):
            self.routeId = data.system?.shuttle?.route?.id
        case .failure(let error):
            Loggers.shared.networkingLogger.error("Error fetching data: \(error)")
        }
    }
}
