//
//  Shuttle.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import Foundation
import SwiftData

// Early throwaway prototype, to be replaced with Passio API
// schema later?

@Model
final class Shuttle {
    var currentLatitude: Double
    var currentLongitude: Double
    
    /// Shuttle label, e.g. "Red Shuttle 17"
    var label: String
    
    /// Estimated time away
    /// Could be returned by Passio API or calculated on-demand
    var estimatedTimeAwayDisplay: String
    
    init(currentLatitude: Double, currentLongitude: Double, label: String, estimatedTimeAwayDisplay: String) {
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
        self.label = label
        self.estimatedTimeAwayDisplay = estimatedTimeAwayDisplay
    }
}
