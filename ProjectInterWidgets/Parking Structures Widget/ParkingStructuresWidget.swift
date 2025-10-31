//
//  ParkingStructureWidget.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import WidgetKit
import SwiftUI
import ProjectInterShared
import Apollo
import ProjectInterOperations



struct ParkingStructuresWidget: Widget {
    let kind: String = "ParkingStructuresWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ParkingStructuresWidgetConfigurationAppIntent.self, provider: ParkingStructuresWidgetTimelineProvider())  { entry in
            if #available(iOS 17.0, *) {
                ParkingStructuresWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ParkingStructuresWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Parking Structures")
        .description("View parking structures for the selected system.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

