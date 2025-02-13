//
//  SetupStateModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

/// Tracks whether to display the setup flow for the app.
class SetupStateModel: ObservableObject {
    @Published var setupCompleted: Bool
    
    init() {
        setupCompleted = UserDefaults.standard.bool(forKey: "setupCompleted")
    }
}
