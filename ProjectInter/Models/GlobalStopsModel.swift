//
//  GlobalStopsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.03.
//

import SwiftUI
import Apollo
import ProjectInterOperations
import MapKit

// MARK: - Models

struct GlobalStopsNetworkArguments {
    let systemId: String
}

struct Coordinates: Equatable {
    var latitude: Double
    var longitude: Double
}

/// Represents a single stop available as part of the selected system.
struct Stop: Identifiable, Equatable {
    var name: String
    var id: String
    var coordinates: Coordinates
}

// MARK: - Data model implementation

class GlobalStopsModel: NetworkDataModelProtocol {
    typealias T = GlobalStopsNetworkArguments
    
    var apolloClient: ApolloClientProtocol?
    
    @Published var stops: [Stop] = []
    @Published var selectedStop: Stop? = nil
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(arguments: GlobalStopsNetworkArguments) {
        let systemId = arguments.systemId
        
        apolloClient?.fetch(query: GetAllStopsBySystemIdQuery(systemId: systemId)) { result in
            guard let data = try? result.get().data else { return }
            guard let stops = data.system?.stops else { return }
            
            self.stops = stops.map { stop in
                let coordinates = Coordinates(latitude: stop.coordinates.latitude, longitude: stop.coordinates.longitude)
                
                return Stop(name: stop.name, id: stop.id, coordinates: coordinates)
            }
        }
    }
    
    /// From the currently saved stops, select the one that is closest to the provided location.
    func selectClosestStopBasedOnLocation(location: CLLocationCoordinate2D) {
        guard var closest = stops.first else { return }
        
        for savedStop in stops {
            // TODO: move conversion of coordinates between types to model struct
            let originalLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let stopLocation = CLLocationCoordinate2D(latitude: savedStop.coordinates.latitude, longitude: savedStop.coordinates.longitude)
            
            let locationOfCurrentClosestStop = CLLocationCoordinate2D(latitude: closest.coordinates.latitude, longitude: closest.coordinates.longitude)
            
            let distanceForCurrentStopInIteration = calculateDistance(originalLocation, stopLocation)
            let distanceForCurrentClosestStop = calculateDistance(originalLocation, locationOfCurrentClosestStop)
            
            if distanceForCurrentClosestStop > distanceForCurrentStopInIteration {
                closest = savedStop
            }
        }
        
        selectedStop = closest
    }
    
    private func calculateDistance(_ location1: CLLocationCoordinate2D, _ location2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let location2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        
        return location1.distance(from: location2)
    }
}

