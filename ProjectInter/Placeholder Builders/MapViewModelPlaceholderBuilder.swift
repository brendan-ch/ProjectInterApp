//
//  MapViewModelBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.06.
//

import Foundation
import CoreLocation

class MapViewModelPlaceholderBuilder {
    private(set) var mapViewModel: MapViewModel?
    
    func build() {
        let newModel = MapViewModel()
        
        newModel.routes = [
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
        
        newModel.shuttles = [
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

        self.mapViewModel = newModel
    }
}
