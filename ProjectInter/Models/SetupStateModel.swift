//
//  SetupStateModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

/// Tracks whether to display the setup flow for the app.
class SetupStateModel: ObservableObject {
    @Published private(set) var setupCompleted: Bool
    
    init() {
        setupCompleted = UserDefaults.standard.bool(forKey: UserDefaults.setupCompletedKey)
    }
    
    func completeSetup() {
        UserDefaults.standard.setValue(true, forKey: UserDefaults.setupCompletedKey)
        setupCompleted = true
    }
}
