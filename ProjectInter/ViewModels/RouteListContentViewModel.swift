//
//  RouteListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations

// MARK: - Models

/// Represents a single route to display in the list of routes.
struct RouteListContentViewRoute: Identifiable {
    /// Server-side ID of the route.
    var id: String
    
    /// The name of the route, e.g. "Red Route."
    var name: String
    
    /// Color to show for the route.
    var colorHex: String
    
    /// Name of the next stop on the route relative to a given stop ID.
    var nextStopName: String?
    
    /// ETAs of shuttles on routes, relative to a given stop ID.
    var etaDisplayString: String
}

// MARK: - Network arguments

/// Information to pass into the route list network request.
struct RouteListNetworkArguments {
    let systemId: String
    let stopId: String
}

// MARK: - View model implementation

/// Backing view model for ``RouteListContentView``.
class RouteListContentViewModel: NetworkDataModelProtocol {
    typealias T = RouteListNetworkArguments

    /// All routes to render on ``RouteListContentView``.
    @Published var routes: [RouteListContentViewRoute] = []
    
    var apolloClient: ApolloClientProtocol?
    
    init() {
        self.apolloClient = nil
    }
    
    init(apolloClient: ApolloClientProtocol) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(arguments: RouteListNetworkArguments) {
        let systemId = arguments.systemId
        let stopId = arguments.stopId
        
        refreshData(systemId: systemId, stopId: stopId)
    }
    
    private func refreshData(systemId: String, stopId: String) {
        apolloClient?.fetch(query: GetRouteListDataQuery(systemId: systemId, stopId: stopId)) { result in
            guard let data = try? result.get().data else { return }
            guard let orderedStops = data.system?.stop?.orderedStops else { return }
            
            self.routes = []
            for orderedStop in orderedStops {
                let route = orderedStop.route
                var routeListRoute = RouteListContentViewRoute(
                    id: route.id,
                    name: route.name,
                    colorHex: route.color,
                    etaDisplayString: "N/A"
                )
                
                if let nextStopName = orderedStop.nextStop?.stop.name {
                    routeListRoute.nextStopName = nextStopName
                } else {
                    routeListRoute.nextStopName = "N/A"
                }
                
                self.routes.append(routeListRoute)
            }
        }
    }
    
}

class RouteListContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias T = RouteListContentViewModel
    
    func build() -> RouteListContentViewModel {
        let newModel = RouteListContentViewModel()
        
        newModel.routes = [
            RouteListContentViewRoute(
                id: "1",
                name: "Red Route",
                colorHex: "#db2316",
                nextStopName: "Chapman Grand",
                etaDisplayString: "8, 12 min"
            ),
            RouteListContentViewRoute(
                id: "2",
                name: "Teal Route",
                colorHex: "#21bdd1",
                nextStopName: "Panther Village",
                etaDisplayString: "5, 15 min"
            ),
        ]
        
        return newModel
    }
}
