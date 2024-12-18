//
//  InterMVP0App.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

@main
struct InterMVP0App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Shuttle.self,
            MockRoute.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let container = try! ModelContainer(for: schema, configurations: modelConfiguration)
        

        return container
    }()
    
    func clearAndInsertMockData() {
        try! sharedModelContainer.mainContext.delete(model: MockRoute.self)
        try! sharedModelContainer.mainContext.delete(model: Shuttle.self)
        
        let routes: [MockRoute] = [
            MockRoute(label: "Red Route", callout: "towards Chapman Grand", colorHex: "#db2316", timeEstimates: "5, 15 min"),
            MockRoute(label: "Teal Route", callout: "towards Panther Village", colorHex: "#21bdd1", timeEstimates: "8, 12 min"),
        ]
        
        for route in routes {
            sharedModelContainer.mainContext.insert(route)
        }
        
        let shuttles = [
            Shuttle(currentLatitude: 33.79964, currentLongitude: -117.89328, label: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away"),
            Shuttle(currentLatitude: 33.78788, currentLongitude: -117.85921, label: "Teal Shuttle 12", estimatedTimeAwayDisplay: "5 min away")
        ]
        
        shuttles[0].route = routes[0]
        
        for shuttle in shuttles {
            sharedModelContainer.mainContext.insert(shuttle)
        }
        
    }

    init() {
        clearAndInsertMockData()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

