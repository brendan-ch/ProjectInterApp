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

struct GlobalStopsNetworkArguments {
    let systemId: String
}

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
                Stop(name: stop.name, id: stop.id)
            }
        }
    }
    
    func selectStopBasedOnClosestLocation(location: CLLocationCoordinate2D) {
        // TODO: Implement this method
    }
}

