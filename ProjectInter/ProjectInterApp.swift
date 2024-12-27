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
    @StateObject var globalDataStateObject = GlobalDataState(apolloClient:
        ApolloClient(url: URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)!)
    )

      var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    globalDataStateObject.refreshSystemData()
                }
                // TODO: remove once UI for selecting system is implemented
                .onChange(of: globalDataStateObject.systems) {
                    if !globalDataStateObject.systems.isEmpty && globalDataStateObject.selectedSystem == nil {
                        globalDataStateObject.selectedSystem = globalDataStateObject.systems[0]
                        if let id = globalDataStateObject.selectedSystem?.id {
                            globalDataStateObject.refreshStopData(systemId: id)
                        }
                    }
                }
                // TODO: remove once UI for selecting stop is implemented
                .onChange(of: globalDataStateObject.stops) {
                    if !globalDataStateObject.stops.isEmpty && globalDataStateObject.selectedStop == nil {
                        globalDataStateObject.selectedStop = globalDataStateObject.stops[0]
                    }
                }
        }
        .environmentObject(globalDataStateObject)
    }
}

