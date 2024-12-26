//
//  ContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ProjectInterOperations

// MARK: - Data models generated from GraphQL fragments

struct Coordinates: Equatable {
    var latitude: Double
    var longitude: Double
}

struct ContentViewShuttle: Equatable, Identifiable {
    var coordinates: Coordinates
    var routeColorHex: String
    var id: String
}

struct ContentViewStop: Equatable, Identifiable {
    var id: String
    var name: String
}

struct ContentViewRoute: Equatable, Identifiable {
    var id: String
    var name: String
    var colorHex: String
    var nextStopName: String?
    var etaDisplayString: String
}

// MARK: - ContentViewModel definition and implementation

protocol ContentViewModelProtocol: ObservableObject {
    var shuttles: [ContentViewShuttle] { get set }
    var stops: [ContentViewStop] { get set }
    var routes: [ContentViewRoute] { get set }
    
    var currentlySelectedStop: ContentViewStop? { get set }
    
    func refreshStopData(systemId: String)
    func refreshShuttlesRoutesEtaData(systemId: String, stopId: String)
}

class ContentViewModel: ContentViewModelProtocol {
    @Published var shuttles: [ContentViewShuttle] = []
    @Published var stops: [ContentViewStop] = []
    @Published var routes: [ContentViewRoute] = []
    
    @Published var currentlySelectedStop: ContentViewStop? = nil
    
    private var apolloClient: ApolloClient
    
    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
    
    func refreshStopData(systemId: String) {
        apolloClient.fetch(query: GetAllStopsBySystemIdQuery(systemId: systemId)) { result in
            guard let data = try? result.get().data else { return }
            
            self.stops = data.system?.stops?.map { stop in
                ContentViewStop(id: stop.id, name: stop.name)
            } ?? []
        }
    }
    
    func refreshShuttlesRoutesEtaData(systemId: String, stopId: String) {
        apolloClient.fetch(query: GetRoutesAndETADataQuery(systemId: systemId, stopId: stopId)) { result in
            guard let data = try? result.get().data else { return }
            
//            if let shuttles = data.system?.shuttles {
//                self.shuttles = shuttles.map { shuttle in
//                    ContentViewShuttle(
//                        coordinates: Coordinates(
//                            latitude: shuttle.coordinates.latitude,
//                            longitude: shuttle.coordinates.longitude
//                        ),
//                        routeColorHex: shuttle.route?.color ?? "#000000",
//                        id: shuttle.id
//                    )
//                }
//            }
            
            self.routes = data.system?.stop?.orderedStops?.map { orderedStop in
                // TODO: compute ETA display time in minutes based on secondsRemaining values
                ContentViewRoute(
                    id: orderedStop.route.id,
                    name: orderedStop.route.name,
                    colorHex: orderedStop.route.color,
                    nextStopName: orderedStop.nextStop?.stop.name,
                    etaDisplayString: "N/A"
                )
            } ?? []
        }
    }
}

class PlaceholderContentViewModel: ContentViewModelProtocol {
    @Published var shuttles: [ContentViewShuttle] = []
    @Published var stops: [ContentViewStop] = []
    @Published var routes: [ContentViewRoute] = []
    
    @Published var currentlySelectedStop: ContentViewStop? = nil
    
    func refreshStopData(systemId: String) {
        stops = [
            ContentViewStop(id: "1", name: "Chapman Grand"),
            ContentViewStop(id: "2", name: "Chapman Court")
        ]
    }
    
    func refreshShuttlesRoutesEtaData(systemId: String, stopId: String) {
        routes = [
            ContentViewRoute(
                id: "1",
                name: "Red Route",
                colorHex: "#db2316",
                nextStopName: "Chapman Grand",
                etaDisplayString: "8, 12 min"
            ),
            ContentViewRoute(
                id: "2",
                name: "Teal Route",
                colorHex: "#21bdd1",
                nextStopName: "Panther Village",
                etaDisplayString: "5, 15 min"
            ),
        ]
    }
    
}
