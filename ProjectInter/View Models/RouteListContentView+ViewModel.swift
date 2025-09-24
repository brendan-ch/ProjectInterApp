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
    
    /// ETAs of upcoming shuttles in seconds relative to a given stop ID.
    private(set) var etasInSeconds: [Double] = []
    
    mutating func addEta(_ newValue: Double) {
        etasInSeconds.append(newValue)
        etasInSeconds.sort()
    }
    
    mutating func clearEtas() {
        etasInSeconds = []
    }
    
    /// ETAs of shuttles on routes, relative to a given stop ID.
    var etaDisplayString: String {
        if etasInSeconds.isEmpty {
            return "N/A"
        }
        
        let etasInMinutesAsStrings: [String] = etasInSeconds.map { $0.convertToMinutesAsString() }
        
        var constructedString = etasInMinutesAsStrings.joined(separator: ", ")
        constructedString.append(" min")
        
        return constructedString
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
    class ViewModel: NetworkDataModel<RouteListNetworkArguments, GetRouteListDataQuery>, PlaceholderBuildable {
        /// All routes to render on ``RouteListContentView``.
        var routes: [RouteListContentViewRoute] = []
        
        override func convertNetworkArgumentsIntoQuery(_ arguments: RouteListNetworkArguments) -> GetRouteListDataQuery {
            return GetRouteListDataQuery(systemId: arguments.systemId, stopId: arguments.stopId)
        }
        
        override func processRefreshDataResult(_ result: Result<GetRouteListDataQuery.Data, any Error>) {
            switch result {
            case .success(let response):
                self.updateDataFromResponse(data: response)
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
        
        private func updateDataFromResponse(data: GetRouteListDataQuery.Data) {
            if let orderedStops = data.system?.stop?.orderedStops {
                self.routes = []
                orderedStops.forEach { orderedStop in
                    if let route = orderedStop.route {
                        var constructedRoute = RouteListContentViewRoute(route)
                        if let nextStop = orderedStop.nextStop?.stop {
                            constructedRoute.nextStopName = nextStop.name
                        }
                        
                        self.routes.append(constructedRoute)
                    }
                }
            }
        }
        
        static func buildPlaceholder() -> Self {
            let newModel = Self(dataInitState: .succeeded)
            newModel.routes = [
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
