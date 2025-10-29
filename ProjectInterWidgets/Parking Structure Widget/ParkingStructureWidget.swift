//
//  ParkingStructureWidget.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import WidgetKit
import SwiftUI

struct ParkingStructureWidget: Widget {
    let kind: String = "ParkingStructureWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ParkingStructureWidgetConfigurationAppIntent.self, provider: ParkingStructureWidgetTimelineProvider()) {
            entry in
            if #available(iOS 17.0, *) {
                ParkingStructureWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ParkingStructureWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }

        }
        .configurationDisplayName("Parking Structure")
        .description("View details of a single parking structure.")
        .supportedFamilies([.systemSmall])
    }
}
