//
//  MapViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import MapKit
import Apollo

// MARK: - Map view model models

struct MapViewRoute: Identifiable {
    var id: String
    var colorHex: String
    var polylineCoordinates: [CLLocationCoordinate2D]
}

struct MapViewShuttle: Identifiable {
    var name: String
    var id: String
    var routeId: String
    var routeColorHex: String
    var coordinates: CLLocationCoordinate2D
}

// MARK: - Map view model implementation

class MapViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .automatic
    
    @Published var routes: [MapViewRoute] = []
    @Published var shuttles: [MapViewShuttle] = []
    
    var apolloClient: ApolloClient?
    
    init(apolloClient: ApolloClient? = nil) {
        self.apolloClient = apolloClient
    }
    
    func addPlaceholderData() {
        routes = [
            MapViewRoute(
                id: "1",
                colorHex: "#db2316",
                polylineCoordinates: [
                    CLLocationCoordinate2D(latitude: 33.79326, longitude: -117.85298),
                    CLLocationCoordinate2D(latitude: 33.79331, longitude: -117.85638),
                    CLLocationCoordinate2D(latitude: 33.78791, longitude: -117.85638),
                    CLLocationCoordinate2D(latitude: 33.78793, longitude: -117.88079),
                    CLLocationCoordinate2D(latitude: 33.78800, longitude: -117.88347),
                ]
            )
        ]
        shuttles = [
            MapViewShuttle(
                name: "Red Shuttle 17",
                id: "1",
                routeId: "1",
                routeColorHex: "#db2316",
                coordinates: CLLocationCoordinate2D(latitude: 33.79964, longitude: -117.89328)
            ),
            MapViewShuttle(
                name: "Red Shuttle 5",
                id: "2",
                routeId: "1",
                routeColorHex: "#db2316",
                coordinates: CLLocationCoordinate2D(latitude: 33.78788, longitude: -117.85921)
            )
        ]
    }
}
