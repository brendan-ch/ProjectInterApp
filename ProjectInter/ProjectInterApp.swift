//
//  InterMVP0App.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData
import Apollo

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
struct ProjectInterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Shuttle.self,
            MockRoute.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let container = try! ModelContainer(for: schema, configurations: modelConfiguration)
        

        return container
    }()
    
    @StateObject var globalDataStateObject = GlobalDataStateObject(apolloClient:
        ApolloClient(url: URL(string: "http://localhost:4000/graphql")!)
    )

    init() {
        PlaceholderDataController.clearAndInsertPlaceholderData(container: sharedModelContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    globalDataStateObject.refreshSystemData()
                }
                .onChange(of: globalDataStateObject.systems) {
                    if !globalDataStateObject.systems.isEmpty && globalDataStateObject.selectedSystem == nil {
                        globalDataStateObject.selectedSystem = globalDataStateObject.systems[0]
                    }
                }
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(globalDataStateObject)
    }
}

