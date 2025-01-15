//
//  ShuttleInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations

/// Information to pass into the shuttle info network request.
struct ShuttleInfoNetworkArguments {
    let systemId: String
    let stopId: String
    let shuttleId: String
}

/// Backing view model for ``ShuttleInfoContentView``.
class ShuttleInfoContentViewModel: NetworkDataModelProtocol {
    typealias T = ShuttleInfoNetworkArguments
    
    /// Name of the shuttle to display.
    @Published var name: String = ""
    
    /// Text representing the ETA of the shuttle relative to the user's selected stop.
    @Published var etaDisplay = ""
    
    var apolloClient: ApolloClientProtocol?
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    var dataRefreshLoopTask: Task<Void, any Error>?

    func refreshDataOnce(arguments: ShuttleInfoNetworkArguments) async {
        let systemId = arguments.systemId
        let stopId = arguments.stopId
        let shuttleId = arguments.shuttleId
        
        await refreshData(systemId: systemId, stopId: stopId, shuttleId: shuttleId)
    }
    
    private func refreshData(systemId: String, stopId: String, shuttleId: String) async {
        return await withCheckedContinuation { continuation in
            guard let apolloClient = apolloClient else {
                continuation.resume()
                return
            }
            
            apolloClient.fetch(query: GetShuttleInfoDataQuery(systemId: systemId, stopId: stopId, shuttleId: shuttleId)) { result in
                defer { continuation.resume() }
                
                guard let data = try? result.get().data else {
                    return
                }
                guard let shuttle = data.system?.shuttle else {
                    return
                }
                
                self.name = shuttle.name
                
                if let secondsRemaining = shuttle.eta?.secondsRemaining {
                    if secondsRemaining < 60 {
                        self.etaDisplay = "Less than 1 min"
                    } else {
                        let minutesRemaining = Int(secondsRemaining / 60)
                        self.etaDisplay = "\(minutesRemaining) min"
                    }
                }
            }
        }
    }
}

class ShuttleInfoContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = ShuttleInfoContentViewModel
    
    func build() -> ShuttleInfoContentViewModel {
        let model = ShuttleInfoContentViewModel()
        model.name = "Red Shuttle 17"
        model.etaDisplay = "5 min away"
        
        return model
    }
}

