//
//  RouteListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations
import ProjectInterLogging

// MARK: - Models

/// Represents a single route to display in the list of routes.
struct RouteListContentViewRoute: Identifiable {
    /// Server-side ID of the route.
    let id: String
    
    /// The name of the route, e.g. "Red Route."
    let name: String
    
    /// Color to show for the route.
    let colorHex: String
    
    /// Name of the next stop on the route relative to a given stop ID.
    var nextStopName: String?
    
    /// ETAs of upcoming shuttles in seconds relative to a given stop ID.
    private(set) var etasInSeconds: [ETASeconds] = []
    
    mutating func addEta(_ newValue: Double) {
        etasInSeconds.append(.init(newValue))
        etasInSeconds.sort()
    }
    
    mutating func clearEtas() {
        etasInSeconds = []
    }
    
    /// ETAs of shuttles on routes, relative to a given stop ID.
    var etaDisplayString: String {
        ETASeconds.convertMultipleIntoShortString(etasInSeconds)
    }
}

extension RouteListContentViewRoute {
    init(_ route: GetRouteListDataQuery.Data.System.Stop.OrderedStop.Route) {
        self.id = route.id
        self.name = route.name
        self.colorHex = route.color
        
        clearEtas()
        route.shuttles?.forEach { shuttle in
            if let secondsRemaining = shuttle.eta?.secondsRemaining {
                addEta(secondsRemaining)
            }
        }
        
        // Next stop name belongs on ordered stop, so not initialized here
    }
}

// Sort routes by name
// Since we're querying by ordered stops, those aren't ordered
// by route name, so we need to perform sorting here
extension RouteListContentViewRoute: Comparable {
    static func < (lhs: RouteListContentViewRoute, rhs: RouteListContentViewRoute) -> Bool {
        lhs.name < rhs.name
    }
}

// MARK: - Network arguments

/// Information to pass into the route list network request.
struct RouteListNetworkArguments {
    let systemId: String
    let stopId: String
}

// MARK: - View model implementation

extension RouteListContentView {
    /// Backing view model for ``RouteListContentView``.
    @Observable
    class ViewModel: NetworkDataModel<GetRouteListDataQuery>, PlaceholderBuildable, Clearable, GraphQLQueryConstructable {
        /// Routes with active shuttles to render on ``RouteListContentView``.
        private(set) var activeRoutes: [RouteListContentViewRoute] = []

        /// Routes without active shuttles to render on ``RouteListContentView``
        private(set) var inactiveRoutes: [RouteListContentViewRoute] = []

        static func convertNetworkArgumentsIntoQuery(_ arguments: RouteListNetworkArguments) -> GetRouteListDataQuery {
            return GetRouteListDataQuery(systemId: arguments.systemId, stopId: arguments.stopId)
        }

        @MainActor
        override func processRefreshDataResult(_ result: Result<GetRouteListDataQuery.Data, any Error>) {
            switch result {
            case .success(let response):
                self.updateDataFromResponse(data: response)
            case .failure(let error):
                Loggers.shared.networkingLogger.error("Error fetching data: \(error)")
            }
        }
        
        private func updateDataFromResponse(data: GetRouteListDataQuery.Data) {
            if let orderedStops = data.system?.stop?.orderedStops {
                var unsortedActiveRoutes: [RouteListContentViewRoute] = []
                var unsortedInactiveRoutes: [RouteListContentViewRoute] = []
                
                orderedStops.forEach { orderedStop in
                    if let route = orderedStop.route {
                        var constructedRoute = RouteListContentViewRoute(route)
                        if let nextStop = orderedStop.nextStop?.stop {
                            constructedRoute.nextStopName = nextStop.name
                        }
                        
                        if let shuttles = route.shuttles, !shuttles.isEmpty {
                            unsortedActiveRoutes.append(constructedRoute)
                        } else {
                            unsortedInactiveRoutes.append(constructedRoute)
                        }
                    }
                }
                
                self.activeRoutes = unsortedActiveRoutes.sorted()
                self.inactiveRoutes = unsortedInactiveRoutes.sorted()
            }
        }
        
        func clearData() {
            activeRoutes = []
            inactiveRoutes = []
        }

        static func buildPlaceholder() -> Self {
            let newModel = Self()
            newModel.activeRoutes = [
                RouteListContentViewRoute(
                    id: "1",
                    name: "Red Route",
                    colorHex: "#db2316",
                    nextStopName: "Chapman Grand",
                    etasInSeconds: [480, 720]
                ),
                RouteListContentViewRoute(
                    id: "2",
                    name: "Teal Route",
                    colorHex: "#21bdd1",
                    nextStopName: "Panther Village",
                    etasInSeconds: [300, 900]
                ),
            ]
            
            return newModel
        }
        
    }
}
