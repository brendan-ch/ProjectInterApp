//
//  ShuttleInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo

class ShuttleInfoContentViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var etaDisplay = ""
    
    var apolloClient: ApolloClient?
    
    init(apolloClient: ApolloClient? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(shuttleId: String) {
        // TODO: implement
    }
    
    func addPlaceholderData() {
        name = "Red Shuttle 17"
        etaDisplay = "5 min away"
    }
}

