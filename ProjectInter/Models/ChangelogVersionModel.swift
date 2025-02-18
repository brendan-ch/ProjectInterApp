//
//  ChangelogVersionModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import Foundation

class ChangelogVersionModel: ObservableObject {
    @Published var shouldShowNewUpdatesIndicator: Bool
    
    private let bundle: Bundle
    private let userDefaults: UserDefaults
    
    init(bundle: Bundle = .main, userDefaults: UserDefaults = .standard) {
        // TODO: initialize this variable
        shouldShowNewUpdatesIndicator = false
        self.bundle = bundle
        self.userDefaults = userDefaults
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
