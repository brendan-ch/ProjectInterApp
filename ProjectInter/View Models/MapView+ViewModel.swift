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
    @Observable
    class ViewModel: NetworkDataModel<MapViewNetworkArguments, GetMapDataQuery> {
        /// Position of the map camera on the associated Map view.
        var position: MapCameraPosition = .automatic
        
        var routes: [MapViewRoute] = []
        var shuttles: [MapViewShuttle] = []
        var stops: [MapViewStop] = []
        var parkingStructures: [MapViewParkingStructure] = []
        
        func convertNetworkArgumentsIntoQuery(_ arguments: MapViewNetworkArguments) -> GetMapDataQuery {
            return GetMapDataQuery(systemId: arguments.systemId)
        }
        
        func processRefreshDataResult(_ result: Result<GetMapDataQuery.Data, Error>) {
            guard let data = try? result.get() else {
                Loggers.shared.networkingLogger.warning("No data received for map data query in \(type(of: self))")
                return
            }
            
            self.shuttles = data.system?.shuttles?.map(MapViewShuttle.init) ?? []
            self.routes = data.system?.routes?.map(MapViewRoute.init) ?? []
            self.stops = data.system?.stops?.map(MapViewStop.init) ?? []
            self.parkingStructures = data.system?.parkingSystem?.parkingStructures?.map(MapViewParkingStructure.init) ?? []
        }
    }
}
