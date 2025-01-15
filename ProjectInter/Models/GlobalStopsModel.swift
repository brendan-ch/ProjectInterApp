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

/// Represents a single stop available as part of the selected system.
struct Stop: Identifiable, Equatable {
    var name: String
    var id: String
    var coordinates: RawCoordinates
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
    
    func startRefreshingData(arguments: GlobalStopsNetworkArguments, sleepDuration: Duration = .seconds(5)) {
        fatalError("This method is not implemented yet.")
    }
    
    func stopRefreshingData() {
        fatalError("This method is not implemented yet.")
    }
    
    func refreshDataOnce(arguments: GlobalStopsNetworkArguments) async {
        return await withCheckedContinuation { continuation in
            let systemId = arguments.systemId
            
            guard let apolloClient = apolloClient else {
                continuation.resume()
                return
            }
            
            apolloClient.fetch(query: GetAllStopsBySystemIdQuery(systemId: systemId)) { result in
                guard let data = try? result.get().data else {
                    continuation.resume()
                    return
                }
                guard let stops = data.system?.stops else {
                    continuation.resume()
                    return
                }
                
                self.stops = stops.map { stop in
                    let coordinates = RawCoordinates(latitude: stop.coordinates.latitude, longitude: stop.coordinates.longitude)
                    
                    return Stop(name: stop.name, id: stop.id, coordinates: coordinates)
                }
                
                continuation.resume()
            }
        }
    }
    
    /// From the currently saved stops, select the one that is closest to the provided location.
    func selectClosestStopBasedOnLocation(location: CLLocationCoordinate2D) {
        guard var closest = stops.first else { return }
        
        for savedStop in stops {
            let stopLocation = savedStop.coordinates.asCLLocationCoordinate2D
            let locationOfCurrentClosestStop = closest.coordinates.asCLLocationCoordinate2D
            
            let distanceForCurrentStopInIteration = calculateDistance(location, stopLocation)
            let distanceForCurrentClosestStop = calculateDistance(location, locationOfCurrentClosestStop)
            
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

class GlobalStopsModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = GlobalStopsModel
    
    func build() -> GlobalStopsModel {
        let newModel = GlobalStopsModel()
        
        newModel.stops = [
            Stop(name: "Chapman Court", id: "1", coordinates: RawCoordinates(latitude: 33.796796, longitude: -117.889293)),
            Stop(name: "Schmid Gate", id: "2", coordinates: RawCoordinates(latitude: 33.793292, longitude: -117.852904))
        ]
        newModel.selectedStop = newModel.stops.first
        
        return newModel
    }
}

