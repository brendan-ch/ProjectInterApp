//
//  RouteListContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo

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
    
    func getRouteData() {
        // TODO: implement data fetch
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
