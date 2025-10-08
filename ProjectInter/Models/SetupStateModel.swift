//
//  SetupStateModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI
import ProjectInterShared
import ProjectInterLogging

/// Tracks whether to display the setup flow for the app.
@Observable
class SetupStateModel {
    private(set) var setupCompleted: Bool {
        get {
            access(keyPath: \.setupCompleted)
            return userDefaults?.bool(forKey: UserDefaults.setupCompletedKey) ?? false
        }
        set {
            withMutation(keyPath: \.setupCompleted) {
                userDefaults?.setValue(newValue, forKey: UserDefaults.setupCompletedKey)
            }
            Loggers.shared.globalStateEventsLogger.notice("Setup completion value set to: \(self.setupCompleted)")
        }

    }
    
    let userDefaults: UserDefaults?
    
    convenience init() {
        self.init(userDefaults: UserDefaults.group)
    }
    
    init(userDefaults: UserDefaults?) {
        self.userDefaults = userDefaults
    }
    
    func completeSetup() {
        setupCompleted = true
    }
}
