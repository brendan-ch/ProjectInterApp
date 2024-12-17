//
//  MockRoute.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI
import SwiftData

// This is just a class used for the MVP mockup
// Not to be used in MVP1 (probably)

@Model
final class MockRoute {
    var label: String
    var callout: String
    var colorHex: String
    var timeEstimates: String
    
    init(label: String, callout: String, colorHex: String, timeEstimates: String) {
        self.label = label
        self.callout = callout
        self.colorHex = colorHex
        self.timeEstimates = timeEstimates
    }
}
