//
//  MapViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import MapKit
import Apollo
import ProjectInterOperations

// MARK: - Models

/// Represents a single route to display on the map.
struct MapViewRoute: Identifiable {
    var id: String
    var colorHex: String
    var polylineCoordinates: [CLLocationCoordinate2D]
}

/// Apollo initializer extension.
extension MapViewRoute {
    init(_ route: GetMapDataQuery.Data.System.Route) {
        self.id = route.id
        self.colorHex = route.color
        
        self.polylineCoordinates = route.polylineCoordinates.map { coordinate in
            CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}

/// Represents a single shuttle to display on the map.
struct MapViewShuttle: Identifiable {
    var name: String
    
    /// The server-side ID of the shuttle.
    var id: String
    
    /// The route ID associated with the shuttle.
    var routeId: String?
    
    /// The color of the associated route, to display with the shuttle.
    var routeColorHex: String?
    
    /// The current coordinates of the shuttle.
    var coordinates: CLLocationCoordinate2D
    
    /// Direction the shuttle is facing in degrees, starting from 0.
    var orientationInDegrees: Double
}

extension MapViewShuttle {
    init(_ shuttle: GetMapDataQuery.Data.System.Shuttle) {
        self.name = shuttle.name
        self.id = shuttle.id
        self.coordinates = CLLocationCoordinate2D(
            latitude: shuttle.coordinates.latitude,
            longitude: shuttle.coordinates.longitude
        )
        
        self.routeId = shuttle.route?.id
        self.routeColorHex = shuttle.route?.color
        self.orientationInDegrees = shuttle.orientationInDegrees
    }
}

/// Represents a stop on the map.
struct MapViewStop: Identifiable {
    /// The server-side ID of the stop.
    var id: String
    
    /// The name of the stop.
    var name: String
    
    /// Coordinates of the stop's location.
    var coordinates: CLLocationCoordinate2D
    
    /// Set of route IDs associated with the stop.
    var routeIds: Set<String> = []
}

extension MapViewStop {
    init(_ stop: GetMapDataQuery.Data.System.Stop) {
        self.id = stop.id
        self.name = stop.name
        self.coordinates = CLLocationCoordinate2D(
            latitude: stop.coordinates.latitude,
            longitude: stop.coordinates.longitude
        )
        
        self.routeIds = []
        stop.orderedStops?.forEach { orderedStop in
            self.routeIds.insert(orderedStop.routeId)
        }
    }
}

/// Represents a parking structure on the map.
struct MapViewParkingStructure: Identifiable {
    var id: String
    var coordinates: CLLocationCoordinate2D
    var name: String
}

extension MapViewParkingStructure {
    init(_ structure: GetMapDataQuery.Data.System.ParkingSystem.ParkingStructure) {
        id = structure.id
        coordinates = CLLocationCoordinate2D(
            latitude: structure.coordinates.latitude,
            longitude: structure.coordinates.longitude
        )
        name = structure.name
    }
}

// MARK: - Network arguments

/// Information to pass into the network request for map data.
struct MapViewNetworkArguments {
    let systemId: String
}

// MARK: - View model implementation

extension MapView {
    /// Backing view model for ``MapView``.
    ///
    /// - TODO: Migrate to the `Observable` macro. Currently, doing this breaks
    /// some rendering updates on the map view.
    class ViewModel: NetworkDataModel<MapViewNetworkArguments, GetMapDataQuery>, PlaceholderBuildable, ObservableObject {
        /// Position of the map camera on the associated Map view.
        @Published var position: MapCameraPosition = .automatic
        
        @Published var routes: [MapViewRoute] = []
        @Published var shuttles: [MapViewShuttle] = []
        @Published var stops: [MapViewStop] = []
        @Published var parkingStructures: [MapViewParkingStructure] = []
        
        override func convertNetworkArgumentsIntoQuery(_ arguments: MapViewNetworkArguments) -> GetMapDataQuery {
            return GetMapDataQuery(systemId: arguments.systemId)
        }
        
        override func processRefreshDataResult(_ result: Result<GetMapDataQuery.Data, Error>) {
            guard let data = try? result.get() else {
                Loggers.shared.networkingLogger.warning("No data received for map data query in \(type(of: self))")
                return
            }
            
            self.shuttles = data.system?.shuttles?.map(MapViewShuttle.init) ?? []
            self.routes = data.system?.routes?.map(MapViewRoute.init) ?? []
            self.stops = data.system?.stops?.map(MapViewStop.init) ?? []
            self.parkingStructures = data.system?.parkingSystem?.parkingStructures?.map(MapViewParkingStructure.init) ?? []
        }
        
        static func buildPlaceholder() -> Self {
            let newModel = Self(dataInitState: .succeeded)
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
}
