//
//  ParkingStructuresWidgetConfigurationAppIntent.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import WidgetKit
import AppIntents

struct ParkingStructuresWidgetConfigurationAppIntent: SystemWidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Parking Structures" }
    static var description: IntentDescription { "View a list of parking structures for a system." }
    
    @Parameter(title: "Mirror system in app", default: true)
    var mirrorSystemInApp: Bool
    
    // Note that the `default` parameter here only applies to UI;
    // we need an optional here for WidgetKit to recognize nil as a
    // valid value
    @Parameter(title: "System", default: .init(
        id: "-1",
        name: "Select a system"
    ))
    var system: SystemEntity?
    
    static var parameterSummary: some ParameterSummary {
        When(\.$mirrorSystemInApp, .equalTo, true) {
            Summary {
                \.$mirrorSystemInApp
            }
        } otherwise: {
            Summary {
                \.$mirrorSystemInApp
                \.$system
            }
        }
    }
}
