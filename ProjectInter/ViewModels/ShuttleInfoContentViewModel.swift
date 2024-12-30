//
//  ShuttleInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations

/// Backing view model for ``ShuttleInfoContentView``.
class ShuttleInfoContentViewModel: ObservableObject {
    /// Name of the shuttle to display.
    @Published var name: String = ""
    
    /// Text representing the ETA of the shuttle relative to the user's selected stop.
    @Published var etaDisplay = ""
    
    var apolloClient: ApolloClient?
    
    init(apolloClient: ApolloClient? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(systemId: String, stopId: String, shuttleId: String) {
        apolloClient?.fetch(query: GetShuttleInfoDataQuery(systemId: systemId, stopId: stopId, shuttleId: shuttleId)) { result in
            guard let data = try? result.get().data else { return }
            guard let shuttle = data.system?.shuttle else { return }
            
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
    
    func addPlaceholderData() {
        name = "Red Shuttle 17"
        etaDisplay = "5 min away"
    }
}

