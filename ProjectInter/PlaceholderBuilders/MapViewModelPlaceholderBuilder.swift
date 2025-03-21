//
//  MapViewModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

import MapKit

/// Builder class to add placeholder data to ``MapViewModel``
/// for previews.
class MapViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = MapViewModel
    
    func build() -> MapViewModel {
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
                    CLLocationCoordinate2D(latitude: 33.788959, longitude: -117.885639),
                    CLLocationCoordinate2D(latitude: 33.789549, longitude: -117.888271),
                    CLLocationCoordinate2D(latitude: 33.789068, longitude: -117.890686),
                    CLLocationCoordinate2D(latitude: 33.792672, longitude: -117.889588),
                    CLLocationCoordinate2D(latitude: 33.794914, longitude: -117.889112),
                    CLLocationCoordinate2D(latitude: 33.799663, longitude: -117.889088),
                    CLLocationCoordinate2D(latitude: 33.799785, longitude: -117.890652),
                    CLLocationCoordinate2D(latitude: 33.797799, longitude: -117.890627),
                    CLLocationCoordinate2D(latitude: 33.797839, longitude: -117.889289)
                ]
            )
        ]
        
        newModel.shuttles = [
            MapViewShuttle(
                name: "Red Shuttle 17",
                id: "1",
                routeId: "1",
                routeColorHex: "#db2316",
                coordinates: CLLocationCoordinate2D(latitude: 33.794334, longitude: -117.889150),
                orientationInDegrees: 10.12
            ),
            MapViewShuttle(
                name: "Red Shuttle 5",
                id: "2",
                routeId: "1",
                routeColorHex: "#db2316",
                coordinates: CLLocationCoordinate2D(latitude: 33.78788, longitude: -117.85921),
                orientationInDegrees: 90.5
            )
        ]
        
        newModel.stops = [
            MapViewStop(
                id: "1",
                name: "Chapman Court",
                coordinates: CLLocationCoordinate2D(latitude: 33.796464, longitude: -117.889352),
                routeIds: Set(["1"])
            ),
            MapViewStop(
                id: "2",
                name: "Schmid Gate",
                coordinates: CLLocationCoordinate2D(latitude: 33.793255, longitude: -117.852755),
                routeIds: Set(["1"])
            )
        ]

        return newModel
    }
}
