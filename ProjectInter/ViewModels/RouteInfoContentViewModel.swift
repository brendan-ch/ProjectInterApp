//
//  RouteInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations

// MARK: - Models

/// Represents a shuttle to render on ``RouteInfoContentView``.
struct RouteInfoContentViewShuttle: Identifiable {
    /// The name of the shuttle.
    var name: String
    
    /// String representing how far away the shuttle is from a given stop,
    /// rendered from server-side data.
    var estimatedTimeAwayDisplay: String
    
    /// The server-side ID of the shuttle.
    var id: String
}

// MARK: - Network arguments

/// Information to pass into the network request for route info.
struct RouteInfoNetworkArguments {
    let systemId: String
    let stopId: String
    let routeId: String
}

// MARK: - View model implementation

/// Backing view model for ``RouteInfoContentView``.
class RouteInfoContentViewModel: NetworkDataModelProtocol {
    typealias T = RouteInfoNetworkArguments
    
    /// The name of the currently viewed route.
    @Published var routeName: String = ""
    
    /// The name of the next stop relative to the user's currently selected stop.
    @Published var routeNextStopName: String? = nil
    
    /// Currently running shuttles to display for the route.
    @Published var shuttles: [RouteInfoContentViewShuttle] = []
    
    var apolloClient: ApolloClientProtocol?
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(arguments: RouteInfoNetworkArguments) {
        let systemId = arguments.systemId
        let stopId = arguments.stopId
        let routeId = arguments.routeId
        
        refreshData(systemId: systemId, stopId: stopId, routeId: routeId)
    }
    
    private func refreshData(systemId: String, stopId: String, routeId: String) {
        apolloClient?.fetch(query: GetRouteInfoDataQuery(systemId: systemId, stopId: stopId, routeId: routeId)) { result in
            guard let data = try? result.get().data else { return }
            guard let route = data.system?.route else { return }
            
            // Set basic route data
            self.routeName = route.name
            if let nextStopName = route.orderedStop?.nextStop?.stop.name {
                self.routeNextStopName = nextStopName
            }
            
            self.shuttles = []
            
            // Add shuttles and calculate ETAs
            if let shuttles = route.shuttles {
                for shuttle in shuttles {
                    var routeInfoContentViewShuttle = RouteInfoContentViewShuttle(
                        name: shuttle.name,
                        estimatedTimeAwayDisplay: "N/A",
                        id: shuttle.id
                    )
                    
                    if let secondsRemaining = shuttle.eta?.secondsRemaining {
                        if secondsRemaining < 60 {
                            routeInfoContentViewShuttle.estimatedTimeAwayDisplay = "Less than 1 min"
                        } else {
                            let minutesRemaining = Int(secondsRemaining / 60)
                            routeInfoContentViewShuttle.estimatedTimeAwayDisplay = "\(minutesRemaining) min"
                        }
                    }
                    
                    self.shuttles.append(routeInfoContentViewShuttle)
                }
            }
        }
    }
    
    func addPlaceholderData() {
        routeName = "Red Route"
        routeNextStopName = "Chapman Grand"
        
        shuttles = [
            RouteInfoContentViewShuttle(name: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away", id: "1"),
            RouteInfoContentViewShuttle(name: "Red Shuttle 5", estimatedTimeAwayDisplay: "15 min away", id: "2"),
        ]
    }
}
