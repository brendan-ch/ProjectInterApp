//
//  SetupStateModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI
import ProjectInterShared

/// Tracks whether to display the setup flow for the app.
@Observable
class SetupStateModel {
    private(set) var setupCompleted: Bool
    
    let userDefaults: UserDefaults
    
    convenience init() {
        self.init(userDefaults: UserDefaults.standard)
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        setupCompleted = self.userDefaults.bool(forKey: UserDefaults.setupCompletedKey)
    }
    
    func completeSetup() {
        userDefaults.setValue(true, forKey: UserDefaults.setupCompletedKey)
        setupCompleted = true
    }
}
