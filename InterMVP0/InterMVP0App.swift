//
//  InterMVP0App.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData

@main
struct InterMVP0App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Shuttle.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let container = try! ModelContainer(for: schema, configurations: modelConfiguration)
    
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
