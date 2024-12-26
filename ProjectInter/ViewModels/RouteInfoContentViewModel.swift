//
//  RouteInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo

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
    
    func refreshData() {
        // TODO: implement
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
