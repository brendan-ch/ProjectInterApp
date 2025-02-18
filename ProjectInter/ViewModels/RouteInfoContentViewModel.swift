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
    
    /// The number of seconds remaining (for sorting).
    var secondsRemaining: Double?
    
    /// String representing how far away the shuttle is from a given stop,
    /// rendered from server-side data.
    var estimatedTimeAwayDisplay: String {
        ETAFormatter.formatSecondsRemaining(secondsRemaining)
    }
    
    /// The server-side ID of the shuttle.
    var id: String
}

extension RouteInfoContentViewShuttle {
    init(_ shuttle: GetRouteInfoDataQuery.Data.System.Route.Shuttle) {
        self.name = shuttle.name
        self.id = shuttle.id
        self.secondsRemaining = shuttle.eta?.secondsRemaining
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
    
    var dataRefreshLoopTask: Task<Void, Error>?
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshDataOnce(arguments: RouteInfoNetworkArguments) async {
        let systemId = arguments.systemId
        let stopId = arguments.stopId
        let routeId = arguments.routeId
        
        await refreshData(systemId: systemId, stopId: stopId, routeId: routeId)
    }
    
    private func refreshData(systemId: String, stopId: String, routeId: String) async {
        return await withCheckedContinuation { continuation in
            var continuationIsActive = true
            guard let apolloClient = apolloClient else {
                continuationIsActive = false
                continuation.resume()
                return
            }
            
            apolloClient.fetch(query: GetRouteInfoDataQuery(systemId: systemId, stopId: stopId, routeId: routeId)) { result in
                if !continuationIsActive {
                    return
                }
                
                switch result {
                case .success(let response):
                    self.updateDataFromResponse(response)
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
                
                continuationIsActive = false
                continuation.resume()
            }
        }
    }
    
    private func updateDataFromResponse(_ response: GraphQLResult<GetRouteInfoDataQuery.Data>) {
        if let data = response.data {
            if let route = data.system?.route {
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
    }
}

class RouteInfoContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = RouteInfoContentViewModel
    
    func build() -> RouteInfoContentViewModel {
        let newModel = RouteInfoContentViewModel()
        
        newModel.routeName = "Red Route"
        newModel.routeNextStopName = "Chapman Grand"
        
        newModel.shuttles = [
            RouteInfoContentViewShuttle(name: "Red Shuttle 17", secondsRemaining: 20, id: "1"),
            RouteInfoContentViewShuttle(name: "Red Shuttle 5", secondsRemaining: 120, id: "2"),
        ]

        return newModel
    }
}
