//
//  RouteListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations

struct RouteListContentViewRoute: Identifiable {
    var id: String
    var name: String
    var colorHex: String
    var nextStopName: String?
    var etaDisplayString: String
}

class RouteListContentViewModel: ObservableObject {
    @Published var routes: [RouteListContentViewRoute] = []
    var apolloClient: ApolloClient?
    
    init() {
        self.apolloClient = nil
    }
    
    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(systemId: String, stopId: String) {
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
    
    func addPlaceholderData() {
        routes = [
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
    }
}
