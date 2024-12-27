//
//  RouteInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations

struct RouteInfoContentViewShuttle: Identifiable {
    var name: String
    var estimatedTimeAwayDisplay: String
    var id: String
}

class RouteInfoContentViewModel: ObservableObject {
    @Published var routeName: String = ""
    @Published var routeNextStopName: String? = nil
    @Published var shuttles: [RouteInfoContentViewShuttle] = []
    
    var apolloClient: ApolloClient?
    
    init(apolloClient: ApolloClient? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(systemId: String, stopId: String, routeId: String) {
        apolloClient?.fetch(query: GetRouteInfoDataQuery(systemId: systemId, stopId: stopId, routeId: routeId)) { result in
            guard let data = try? result.get().data else { return }
            guard let route = data.system?.route else { return }
            
            self.routeName = route.name
            if let nextStopName = route.orderedStop?.nextStop?.stop.name {
                self.routeNextStopName = nextStopName
            }
            
            self.shuttles = []
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
