//
//  ChangelogVersionModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import Foundation

class ChangelogVersionModel: ObservableObject {
    @Published var shouldShowNewUpdatesIndicator: Bool
    
    init() {
        // TODO: initialize this variable
        shouldShowNewUpdatesIndicator = false
    }
    
    private func getCurrentAppMarketingVersion() -> String {
        // TODO: implement
        return ""
    }
    
    private func getLastViewedChangelogVersion() -> String {
        // TODO: implement
        return ""
    }
    
    func updateLastViewedChangelogVersion() {
        // TODO: Perform the update
    }
}
