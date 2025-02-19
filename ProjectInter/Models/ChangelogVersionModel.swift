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
        self.bundle = bundle
        self.userDefaults = userDefaults
        self.shouldShowNewUpdatesIndicator = false
        
        let currentVersion = getCurrentAppMarketingVersion()
        let lastViewedVersion = getLastViewedChangelogVersion()
        self.shouldShowNewUpdatesIndicator = currentVersion != lastViewedVersion
    }
    
    private func getCurrentAppMarketingVersion() -> String? {
        let marketingVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return marketingVersion
    }
    
    private func getLastViewedChangelogVersion() -> String? {
        let lastViewedChangelogVersion = userDefaults.string(forKey: UserDefaults.lastViewedChangelogVersionKey) ?? ""
        return lastViewedChangelogVersion
    }
    
    func updateLastViewedChangelogVersion() {
        let marketingVersion = getCurrentAppMarketingVersion()
        userDefaults.setValue(marketingVersion, forKey: UserDefaults.lastViewedChangelogVersionKey)
        shouldShowNewUpdatesIndicator = false
    }
}
