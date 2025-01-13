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

/// Represents a single shuttle to display on the map.
struct MapViewShuttle: Identifiable {
    var name: String
    
    /// The server-side ID of the shuttle.
    var id: String
    
    /// The route ID associated with the shuttle.
    var routeId: String
    
    /// The color of the associated route, to display with the shuttle.
    var routeColorHex: String
    
    /// The current coordinates of the shuttle.
    var coordinates: CLLocationCoordinate2D
}

// MARK: - Network arguments

/// Information to pass into the network request for map data.
struct MapViewNetworkArguments {
    let systemId: String
}

// MARK: - View model implementation

/// Backing view model for ``MapView``.
class MapViewModel: NetworkDataModelProtocol {
    /// Position of the map camera on the associated Map view.
    @Published var position: MapCameraPosition = .automatic
    
    @Published var routes: [MapViewRoute] = []
    @Published var shuttles: [MapViewShuttle] = []
    
    var apolloClient: ApolloClientProtocol?
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshDataOnce(arguments: MapViewNetworkArguments) async {
        let systemId = arguments.systemId
        
        await refreshData(systemId: systemId)
    }
    
//    func refreshDataOnce(arguments: MapViewNetworkArguments) {
//        let systemId = arguments.systemId
//        
//        refreshData(systemId: systemId)
//    }
    
    private func refreshData(systemId: String) async {
        return await withCheckedContinuation { continuation in
            guard let apolloClient = apolloClient else {
                continuation.resume()
                return
            }
            
            apolloClient.fetch(query: GetMapDataQuery(systemId: systemId)) { result in
                guard let data = try? result.get().data else {
                    continuation.resume()
                    return
                }
                
                self.shuttles = []
                let shuttles = data.system?.shuttles ?? []
                for shuttle in shuttles {
                    if let route = shuttle.route {
                        let coordinates = CLLocationCoordinate2D(latitude: shuttle.coordinates.latitude, longitude: shuttle.coordinates.longitude)
                        
                        let mapViewShuttle = MapViewShuttle(name: shuttle.name, id: shuttle.id, routeId: route.id, routeColorHex: route.color, coordinates: coordinates)
                        
                        self.shuttles.append(mapViewShuttle)
                    }
                }
                
                self.routes = []
                let routes = data.system?.routes ?? []
                for route in routes {
                    let polylineCoordinates = route.polylineCoordinates
                    let mapViewRoutePolylineCoordinates = polylineCoordinates.map { coordinate in
                        CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    }
                    
                    let mapViewRoute = MapViewRoute(id: route.id, colorHex: route.color, polylineCoordinates: mapViewRoutePolylineCoordinates)
                    
                    self.routes.append(mapViewRoute)
                }
                
                continuation.resume()
            }
        }
    }
}

/// Builder class to add placeholder data to ``MapViewModel``,
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

        return newModel
    }
}
