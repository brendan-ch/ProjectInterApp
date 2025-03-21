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
struct GlobalStopsModelStop: Identifiable, Equatable {
    var name: String
    var id: String
    var coordinates: RawCoordinates
    var routeIds: Set<String> = []
}

extension GlobalStopsModelStop {
    init(_ stop: GetAllStopsBySystemIdQuery.Data.System.Stop) {
        self.coordinates = RawCoordinates(latitude: stop.coordinates.latitude, longitude: stop.coordinates.longitude)
        
        self.name = stop.name
        self.id = stop.id
        
        guard let orderedStops = stop.orderedStops else { return }
        for orderedStop in orderedStops {
            self.routeIds.insert(orderedStop.routeId)
        }
    }
}

// MARK: - Data model implementation

class GlobalStopsModel: NetworkDataModelProtocol {
    
    typealias T = GlobalStopsNetworkArguments
    
    var apolloClient: ApolloClientProtocol?
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    @Published var stops: [GlobalStopsModelStop] = []
    @Published private(set) var selectedStop: GlobalStopsModelStop? = nil
    @Published var selectedStopIdOnMap: String? = nil
    
    /// Indicates whether the stop is automatically being selected via location
    /// (via coordination with ``GlobalLocationDataModel``). Manual
    /// selection of a stop by calling ``selectStopManually(stop:)``
    /// sets this to false.
    @Published var isAutomaticWhenLocationIsAvailable: Bool = false
    
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
                
                self.stops = stops.map(GlobalStopsModelStop.init)
                self.stops.sort { $0.name < $1.name }
                
                continuation.resume()
            }
        }
    }
    
    func selectStopManually(_ stop: GlobalStopsModelStop) {
        selectedStop = stop
        isAutomaticWhenLocationIsAvailable = false
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

