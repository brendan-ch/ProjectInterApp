//
//  ParkingStructureWidgetConfigurationAppIntent.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import WidgetKit
import AppIntents
import ProjectInterShared

struct ParkingStructureWidgetConfigurationAppIntent: SystemWidgetConfigurationIntent {
    static var title: LocalizedStringResource {
        "Parking Structure"
    }
    static var description: IntentDescription {
        "View a parking structure."
    }
    
    @Parameter(title: "Mirror system in app", default: true)
    var mirrorSystemInApp: Bool
    
    @Parameter(title: "System", default: .init(
        id: "-1",
        name: "Select a system"
    ))
    var system: SystemEntity?
    
    @Parameter(title: "Parking structure", default: .init(
        id: "-1",
        name: "Select a parking structure"
    ))
    var parkingStructure: ParkingStructureEntity?
    
    static var parameterSummary: some ParameterSummary {
        When(\.$mirrorSystemInApp, .equalTo, true) {
            Summary {
                \.$mirrorSystemInApp
                \.$parkingStructure
            }
        } otherwise: {
            Summary {
                \.$mirrorSystemInApp
                \.$system
                \.$parkingStructure
            }
        }
    }
}
