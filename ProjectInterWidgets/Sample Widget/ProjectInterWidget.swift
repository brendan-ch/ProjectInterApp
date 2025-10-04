//
//  ProjectInterWidgets.swift
//  ProjectInterWidgets
//
//  Created by Brendan Chen on 2025.10.03.
//

import WidgetKit
import SwiftUI
import ProjectInterShared
import Apollo
import ProjectInterOperations

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SchemaVersionEntry {
        SchemaVersionEntry(date: Date(), status: .succeeded, minVersion: 1, currentVersion: 1)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SchemaVersionEntry) -> ()) {
        let entry = SchemaVersionEntry(date: Date(), status: .succeeded, minVersion: 1, currentVersion: 1)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SchemaVersionEntry] = []
        let date = Date()
        let fifteenMinutesLater = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
        
        Task.detached {
            if let entry = try? await SchemaVersionEntry.create(GetSchemaVersionQuery()) {
                entries.append(entry)
            } else {
                entries.append(.init(
                    date: .now,
                    status: .failed(error: "Unable to create entry"),
                    minVersion: nil,
                    currentVersion: nil
                ))
            }
            
            let timeline = Timeline(entries: entries, policy: .after(fifteenMinutesLater))
            completion(timeline)
        }
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

enum TimelineEntryStatus: Equatable {
    static func == (lhs: TimelineEntryStatus, rhs: TimelineEntryStatus) -> Bool {
        switch (lhs, rhs) {
        case (.succeeded, .succeeded):
            return true
        case (.failed, failed):
            return true
        default:
            return false
        }
    }
    
    case succeeded
    case failed(error: String)
}

struct SchemaVersionEntry: TimelineEntry, GraphQLConstructable {
    static func create(_ query: ProjectInterOperations.GetSchemaVersionQuery) async throws -> SchemaVersionEntry {
        let result = try await getGraphQLResult(query)
        guard let data = result.data else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        
        return .init(
            date: .now,
            status: .succeeded,
            minVersion: data.schemaMinVersion,
            currentVersion: data.schemaCurrentVersion
        )
    }
    
    typealias Query = GetSchemaVersionQuery

    let date: Date
    let status: TimelineEntryStatus
    
    let minVersion: Int?
    let currentVersion: Int?
}

struct ProjectInterWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Date:")
            Text(entry.date, style: .time)
            
            if case let .failed(message) = entry.status {
                Text(message)
            }
            
            if entry.status == .succeeded,
               let minVersion = entry.minVersion,
               let currentVersion = entry.currentVersion {
                Text("Minimum version:")
                Text("\(minVersion)")
                
                Text("Current version:")
                Text("\(currentVersion)")
            }
            
        }
    }
}

struct ProjectInterWidget: Widget {
    let kind: String = "ProjectInterWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ProjectInterWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ProjectInterWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    ProjectInterWidget()
} timeline: {
    SchemaVersionEntry(date: .now, status: .succeeded, minVersion: 1, currentVersion: 2)
    SchemaVersionEntry(date: .now, status: .succeeded, minVersion: 2, currentVersion: 3)
}
