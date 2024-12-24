//
//  MockRoute.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI
import SwiftData
import CoreLocation

struct StoredCoordinate: Codable, Hashable {
    var latitude: Double
    var longitude: Double
}

@Model
final class MockRoute {
    var label: String
    var callout: String
    var colorHex: String
    var timeEstimates: String
    
    var coordinates: [StoredCoordinate]
    
    @Relationship(deleteRule: .cascade, inverse: \Shuttle.route)
    var shuttles = [Shuttle]()
    
    init(label: String, callout: String, colorHex: String, timeEstimates: String) {
        self.label = label
        self.callout = callout
        self.colorHex = colorHex
        self.timeEstimates = timeEstimates
        self.coordinates = []
        
        self.shuttles = []
    }
}
