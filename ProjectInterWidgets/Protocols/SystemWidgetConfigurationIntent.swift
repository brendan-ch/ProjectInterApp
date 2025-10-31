//
//  SystemWidgetConfigurationAppIntent.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import WidgetKit
import AppIntents
import ProjectInterShared

protocol SystemWidgetConfigurationIntent: WidgetConfigurationIntent {
    var mirrorSystemInApp: Bool { get set }
    var system: SystemEntity? { get set }
}

extension SystemWidgetConfigurationIntent {
    func getSystemId(
        userDefaults: UserDefaults? = .group
    ) -> String? {
        var systemId = self.system?.id
        if self.mirrorSystemInApp,
           let systemIdFromUserDefaults = userDefaults?.string(forKey: UserDefaults.selectedSystemIdKey) {
            systemId = systemIdFromUserDefaults
        }
        
        return systemId
    }
}

extension IntentProjection where Intent: SystemWidgetConfigurationIntent {
    func getSystemId(
        userDefaults: UserDefaults? = .group
    ) -> String? {
        var systemId = self.system.id
        if self.mirrorSystemInApp,
           let systemIdFromUserDefaults = userDefaults?.string(forKey: UserDefaults.selectedSystemIdKey) {
            systemId = systemIdFromUserDefaults
        }
        
        return systemId
    }
}
