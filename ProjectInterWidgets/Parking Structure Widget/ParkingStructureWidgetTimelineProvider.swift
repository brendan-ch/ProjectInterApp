//
//  ParkingStructureWidgetTimelineProvider.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import ProjectInterShared
import WidgetKit
import ProjectInterOperations

struct ParkingStructureWidgetTimelineProvider: UserDefaultsAppIntentTimelineProvider {
    typealias Entry = ParkingStructureWidgetEntry
    typealias Intent = ParkingStructureWidgetConfigurationAppIntent
    
    internal let userDefaults: UserDefaults?
    
    init(userDefaults: UserDefaults? = .group) {
        self.userDefaults = userDefaults
    }
    
    func placeholder(in context: Context) -> ParkingStructureWidgetEntry {
        return .init(
            systemId: nil,
            date: .now,
            parkingStructure: .mock,
            status: .succeeded,
        )
    }
    
    func snapshot(for configuration: ParkingStructureWidgetConfigurationAppIntent, in context: Context) async -> ParkingStructureWidgetEntry {
        return .init(
            systemId: nil,
            date: .now,
            parkingStructure: .mock,
            status: .succeeded,
        )
    }
    
    func timeline(for configuration: ParkingStructureWidgetConfigurationAppIntent, in context: Context) async -> Timeline<ParkingStructureWidgetEntry> {
        let systemId = configuration.getSystemId(userDefaults: userDefaults)
        
        if !setupCompleted {
            return timelineForFailingEntryWithError(error: "To use this widget, complete app setup.")
        }
        
        guard let systemId = systemId else {
            return timelineForFailingEntryWithError(error: "Tap and hold to configure this widget and select a system.")
        }
        
        guard let parkingStructure = configuration.parkingStructure else {
            return timelineForFailingEntryWithError(error: "Tap and hold to configure this widget and select a parking structure.")
        }
        
        guard let entry = try? await ParkingStructureWidgetEntry.create(GetParkingStructureInfoDataQuery(systemId: systemId, parkingStructureId: parkingStructure.id, historicalAveragesInput: nil)) else {
            return timelineForFailingEntryWithError(error: "Unable to get parking structure; please try again later.")
        }
        
        return timelineForEntry(entry)
    }
    
    func timelineForFailingEntryWithError(error: String) -> Timeline<ParkingStructureWidgetEntry> {
        return timelineForEntry(.init(
            systemId: nil,
            date: .now,
            parkingStructure: nil,
            status: .failed(error: error)
        ))
    }
    
    func timelineForEntry(_ entry: ParkingStructureWidgetEntry) -> Timeline<ParkingStructureWidgetEntry> {
        return timelineForEntries([entry])
    }
    
    func timelineForEntries(_ entries: [ParkingStructureWidgetEntry]) -> Timeline<ParkingStructureWidgetEntry> {
        return Timeline(entries: entries, policy: .atEnd)
    }
}
