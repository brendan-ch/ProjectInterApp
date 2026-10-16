//
//  RouteInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations
import ProjectInterLogging

// MARK: - Models

/// Represents a shuttle to render on ``RouteInfoContentView``.
struct RouteInfoContentViewShuttle: Identifiable, Equatable {
    /// The name of the shuttle.
    var name: String
    
    /// The number of seconds remaining (for sorting).
    var secondsRemaining: ETASeconds?
    
    /// String representing how far away the shuttle is from a given stop,
    /// rendered from server-side data.
    var estimatedTimeAwayDisplay: String {
        if let secondsRemaining = secondsRemaining {
            return secondsRemaining.asShortString()
        }
        return "N/A"
    }
    
    /// The server-side ID of the shuttle.
    var id: String
}

extension RouteInfoContentViewShuttle {
    init(_ shuttle: GetRouteInfoDataQuery.Data.System.Route.Shuttle) {
        self.name = shuttle.name
        self.id = shuttle.id
        if let secondsRemaining = shuttle.eta?.secondsRemaining {
            self.secondsRemaining = ETASeconds(secondsRemaining)
        }
    }
}

// MARK: - Network arguments

/// Information to pass into the network request for route info.
struct RouteInfoNetworkArguments {
    let systemId: String
    let stopId: String
    let routeId: String
}

// MARK: - View model implementation

extension RouteInfoContentView {
    /// Backing view model for ``RouteInfoContentView``.
    @Observable
    class ViewModel: NetworkDataModel<GetRouteInfoDataQuery>, PlaceholderBuildable, Clearable, GraphQLQueryConstructable {
        /// The name of the currently viewed route.
        var routeName: String = ""

        /// The name of the next stop relative to the user's currently selected stop.
        var routeNextStopName: String? = nil

        /// Currently running shuttles to display for the route.
        var shuttles: [RouteInfoContentViewShuttle] = []

        static func convertNetworkArgumentsIntoQuery(_ arguments: RouteInfoNetworkArguments) -> GetRouteInfoDataQuery {
            return GetRouteInfoDataQuery(
                systemId: arguments.systemId,
                stopId: arguments.stopId,
                routeId: arguments.routeId
            )
        }

        @MainActor
        override func processRefreshDataResult(_ result: Result<GetRouteInfoDataQuery.Data, any Error>) {
            switch result {
            case .success(let response):
                self.updateDataFromResponse(response)
            case .failure(let error):
                Loggers.shared.networkingLogger.error("Error fetching data: \(error)")
            }
        }
        
        private func updateDataFromResponse(_ response: GetRouteInfoDataQuery.Data) {
            if let route = response.system?.route {
                // Set basic route data
                self.routeName = route.name
                if let nextStopName = route.orderedStop?.nextStop?.stop?.name {
                    self.routeNextStopName = nextStopName
                }
                
                self.shuttles = route.shuttles?.map(RouteInfoContentViewShuttle.init) ?? []
                
                self.shuttles.sort {
                    if $0.secondsRemaining != nil {
                        if $1.secondsRemaining != nil {
                            return $0.secondsRemaining! < $1.secondsRemaining!
                        }
                        return true
                    }
                    return false
                }
            }
        }
        
        func clearData() {
            routeName = ""
            shuttles = []
            routeNextStopName = nil
        }

        static func buildPlaceholder() -> Self {
            let newModel = Self()
            newModel.routeName = "Red Route"
            newModel.routeNextStopName = "Chapman Grand"
            
            newModel.shuttles = [
                RouteInfoContentViewShuttle(name: "Red Shuttle 17", secondsRemaining: 20, id: "1"),
                RouteInfoContentViewShuttle(name: "Red Shuttle 5", secondsRemaining: .init(120), id: "2"),
            ]
            
            return newModel
        }
    }
}
