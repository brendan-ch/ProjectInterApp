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
        
        let etasInMinutesAsStrings: [String] = etasInSeconds.map { etaInSeconds in
            let etaInMinutes = Int(etaInSeconds / 60)
            if etaInMinutes < 1 {
                return "<1"
            } else {
                return String(etaInMinutes)
            }
        }
        
        var constructedString = etasInMinutesAsStrings.joined(separator: ", ")
        constructedString.append(" min")
        
        return constructedString
    }
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
    
    private var task: Task<Void, Error>?
    
    private var continuationIsActive = false
    
    init() {
        self.apolloClient = nil
    }
    
    init(apolloClient: ApolloClientProtocol) {
        self.apolloClient = apolloClient
    }
    
    func startRefreshingData(arguments: RouteListNetworkArguments, sleepDuration: Duration = .seconds(5)) {
        if task != nil {
            return
        }
        
        task = Task {
            while !Task.isCancelled {
                await refreshDataOnce(arguments: arguments)
                try? await Task.sleep(for: sleepDuration)
            }
        }
    }
    
    func stopRefreshingData() {
        task?.cancel()
        task = nil
    }
    
    func refreshDataOnce(arguments: RouteListNetworkArguments) async {
        let systemId = arguments.systemId
        let stopId = arguments.stopId
        
        await refreshData(systemId: systemId, stopId: stopId)
    }
    
    private func refreshData(systemId: String, stopId: String) async {
        return await withCheckedContinuation { continuation in
            continuationIsActive = true
            guard let apolloClient = apolloClient else {
                continuation.resume()
                return
            }
            
            let _ = apolloClient.fetch(
                query: GetRouteListDataQuery(systemId: systemId, stopId: stopId),
                cachePolicy: .fetchIgnoringCacheData,
                context: nil,
                queue: .main
            ) { result in
                // Handle cases where callback is called multiple times
                if !self.continuationIsActive {
                    return
                }
                
                switch result {
                case .success(let response):
                    self.updateDataFromResponse(response: response)
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
                
                self.continuationIsActive = false
                continuation.resume()
            }
        }
    }
    
    private func updateDataFromResponse(response: GraphQLResult<GetRouteListDataQuery.Data>) {
        if let data = response.data {
            if let orderedStops = data.system?.stop?.orderedStops {
                self.routes = []
                for orderedStop in orderedStops {
                    let route = orderedStop.route
                    var routeListRoute = RouteListContentViewRoute(
                        id: route.id,
                        name: route.name,
                        colorHex: route.color
                    )
                    
                    if let nextStopName = orderedStop.nextStop?.stop.name {
                        routeListRoute.nextStopName = nextStopName
                    } else {
                        routeListRoute.nextStopName = "N/A"
                    }
                    
                    if let shuttles = orderedStop.route.shuttles {
                        for shuttle in shuttles {
                            if let secondsRemaining = shuttle.eta?.secondsRemaining {
                                routeListRoute.addEta(secondsRemaining)
                            }
                        }
                    }
                    
                    self.routes.append(routeListRoute)
                }
            }
        }
    }
    
}

class RouteListContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = RouteListContentViewModel
    
    func build() -> RouteListContentViewModel {
        let newModel = RouteListContentViewModel()
        
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
