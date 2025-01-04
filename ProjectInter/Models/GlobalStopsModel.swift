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
    
    func selectStopBasedOnClosestLocation(location: CLLocationCoordinate2D) {
        // TODO: Implement this method
    }
}

