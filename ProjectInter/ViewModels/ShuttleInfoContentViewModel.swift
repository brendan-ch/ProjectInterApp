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

/// Displays the ETA and seconds remaining for the currently open shuttle.
struct ShuttleInfoEtaListItem {
    let stopName: String
    let secondsRemaining: Double
    let stopId: String
    
    var estimatedTimeAwayDisplay: String {
        ETAFormatter.formatSecondsRemaining(secondsRemaining)
    }
}

/// Backing view model for ``ShuttleInfoContentView``.
class ShuttleInfoContentViewModel: NetworkDataModelProtocol {
    typealias T = ShuttleInfoNetworkArguments
    
    /// Name of the shuttle to display.
    @Published var name: String = ""
    
    /// Text representing the ETA of the shuttle relative to the user's selected stop.
    @Published var etaDisplay = ""
    
    @Published var etaListItems: [ShuttleInfoEtaListItem] = []
    
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
            var continuationIsActive = true
            guard let apolloClient = apolloClient else {
                continuationIsActive = false
                continuation.resume()
                return
            }
            
            apolloClient.fetch(query: GetShuttleInfoDataQuery(systemId: systemId, shuttleId: shuttleId)) { result in
                defer {
                    continuationIsActive = false
                    continuation.resume()
                }
                
                if !continuationIsActive {
                    return
                }
                
                guard let data = try? result.get().data else {
                    return
                }
                guard let shuttle = data.system?.shuttle else {
                    return
                }
                
                self.name = shuttle.name
                
                if let etas = shuttle.etas {
                    self.etaListItems = []
                    for eta in etas {
                        if eta.stop.id == stopId {
                            self.etaDisplay = ETAFormatter.formatSecondsRemaining(eta.secondsRemaining)
                        }
                        
                        self.etaListItems.append(ShuttleInfoEtaListItem(
                            stopName: eta.stop.name,
                            secondsRemaining: eta.secondsRemaining,
                            stopId: eta.stop.id
                        ))
                    }
                    self.etaListItems.sort {
                        $0.secondsRemaining < $1.secondsRemaining
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
        
        model.etaListItems = [
            .init(stopName: "Schmid Gate", secondsRemaining: 125, stopId: "1"),
            .init(stopName: "Panther Village", secondsRemaining: 300, stopId: "2"),
            .init(stopName: "Chapman Grand", secondsRemaining: 1430, stopId: "3")
        ]
        
        return model
    }
}

