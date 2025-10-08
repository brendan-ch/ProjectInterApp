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

struct ParkingStructuresWidgetTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = ParkingStructuresWidgetEntry
    typealias Intent = ParkingStructuresWidgetConfigurationAppIntent
    
    func placeholder(in context: Context) -> ParkingStructuresWidgetEntry {
        return .init(
            date: .now,
            parkingStructures: [
                .mock
            ],
            status: .succeeded,
        )
    }
    
    func snapshot(for configuration: ParkingStructuresWidgetConfigurationAppIntent, in context: Context) async -> ParkingStructuresWidgetEntry {
        return .init(
            date: .now,
            parkingStructures: [
                .mock
            ],
            status: .succeeded,
        )
    }
    
    func timeline(for configuration: ParkingStructuresWidgetConfigurationAppIntent, in context: Context) async -> Timeline<ParkingStructuresWidgetEntry> {
        var entries: [ParkingStructuresWidgetEntry] = []
        
        var systemId = configuration.system.id
        if configuration.mirrorSystemInApp,
           let systemIdFromUserDefaults = UserDefaults.group?.string(forKey: UserDefaults.selectedSystemIdKey) {
            systemId = systemIdFromUserDefaults
        }
        
        if let entry = try? await ParkingStructuresWidgetEntry.create(GetParkingStructuresListDataQuery(systemId: systemId)) {
            entries.append(entry)
        } else {
            entries.append(.init(
                date: .now,
                parkingStructures: nil,
                status: .failed(error: "Unable to get parking structures")
            ))
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        return timeline
    }
}

struct ParkingStructuresWidgetEntry: TimelineEntry, GraphQLConstructable {
    typealias Query = GetParkingStructuresListDataQuery
    
    struct ParkingStructure: Identifiable {
        let id: String
        let name: String
        let capacity: Int
        let spotsAvailable: Int
    }
    
    let date: Date
    let parkingStructures: [ParkingStructure]?
    let status: TimelineEntryStatus
    
    static func create(_ query: ProjectInterOperations.GetParkingStructuresListDataQuery) async throws -> ParkingStructuresWidgetEntry {
        let result = try await getGraphQLResult(query)
        guard let structures = result.data?.system?.parkingSystem?.parkingStructures else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        return .init(
            date: .now,
            // TODO: Bridge with parking structures in ParkingStructuresListContentView+ViewModel
            parkingStructures: structures.map { structure in
                .init(
                    id: structure.id,
                    name: structure.name,
                    capacity: structure.capacity,
                    spotsAvailable: structure.spotsAvailable
                )
            },
            status: .succeeded
        )
    }
}

extension ParkingStructuresWidgetEntry.ParkingStructure {
    static let mock: ParkingStructuresWidgetEntry.ParkingStructure = .init(
        id: "1",
        name: "Parking Structure A",
        capacity: 100,
        spotsAvailable: 40
    )
}

struct ParkingStructuresWidgetEntryView: View {
    let entry: ParkingStructuresWidgetEntry
    
    var body: some View {
        VStack {
            if let structures = entry.parkingStructures {
                ForEach(structures) { structure in
                    Text(structure.name)
                }
            }
            if case let .failed(message) = entry.status {
                Text("\(message)")
            }
        }
    }
}

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
    }
}

#Preview(as: .systemMedium) {
    ParkingStructuresWidget()
} timeline: {
    ParkingStructuresWidgetEntry(
        date: .now,
        parkingStructures: [
            .mock
        ],
        status: .succeeded
    )
}

