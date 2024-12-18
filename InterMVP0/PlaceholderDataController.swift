//
//  PlaceholderDataController.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.18.
//

import Foundation
import SwiftData
import CoreLocation

@MainActor
class PlaceholderDataController {
    /// Preview data container to be used for SwiftUI previews.
    static let previewContainer: ModelContainer = {
        let schema = Schema([
            Shuttle.self,
            MockRoute.self,
        ])
        
        let options = ModelConfiguration(isStoredInMemoryOnly: true)
        
        let container = try! ModelContainer(for: schema, configurations: [options])
        
        clearAndInsertPlaceholderData(container: container)
        
        return container
    }()
    
    static func clearAndInsertPlaceholderData(container: ModelContainer) {
        try! container.mainContext.delete(model: MockRoute.self)
        try! container.mainContext.delete(model: Shuttle.self)
        
        let routes: [MockRoute] = [
            MockRoute(label: "Red Route", callout: "towards Chapman Grand", colorHex: "#db2316", timeEstimates: "5, 15 min"),
            MockRoute(label: "Teal Route", callout: "towards Panther Village", colorHex: "#21bdd1", timeEstimates: "8, 12 min"),
        ]
        
        for route in routes {
            container.mainContext.insert(route)
        }
        
        let shuttles = [
            Shuttle(currentLatitude: 33.79964, currentLongitude: -117.89328, label: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away"),
            Shuttle(currentLatitude: 33.78788, currentLongitude: -117.85921, label: "Teal Shuttle 12", estimatedTimeAwayDisplay: "5 min away")
        ]
        
        shuttles[0].route = routes[0]
        
        for shuttle in shuttles {
            container.mainContext.insert(shuttle)
        }
        
    }
}
