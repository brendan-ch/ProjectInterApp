//
//  UserDefaults.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import Foundation

public extension UserDefaults {
    static var setupCompletedKey: String { "setupCompleted" }
    static var lastViewedChangelogVersionKey: String { "lastViewedChangelogVersion" }
    static var uiTestsKey: String { "uiTests" }
    static var mockNotificationsTokenKey: String { "mockNotificationsToken" }
    static var selectedSystemIdKey: String { "selectedSystemId" }
    
    /// Value that is written to `selectedSystemIdKey` on app startup.
    static var initialSystemIdKey: String { "initialSystemId" }

    static var customServerUrlKey: String { "customServerUrl" }
    static var hiddenStopIdsKey: String { "hiddenStopIds" }
    
    static let group: UserDefaults? = .init(suiteName: "group.dev.bchen.Inter")
}
