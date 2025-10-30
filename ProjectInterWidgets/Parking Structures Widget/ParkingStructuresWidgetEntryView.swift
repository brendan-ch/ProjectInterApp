//
//  ParkingStructuresWidgetEntryView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.07.
//

import WidgetKit
import SwiftUI
import ProjectInterShared
import ProjectInterWidgetsCore

struct ParkingStructuresWidgetEntryView: View {
    let entry: ParkingStructuresWidgetEntry
    
    var body: some View {
        VStack(spacing: 16) {
            if let structures = entry.parkingStructures,
               let systemId = entry.systemId {
                ForEach(structures) { structure in
                    let arguments = OpenParkingStructureArguments(parkingStructureId: structure.id, systemId: systemId)
                    if let link = arguments.toUrl() {
                        Link(destination: link) {
                            ParkingStructuresWidgetListItem(structure: structure)
                        }
                    }
                }
            }
            if case let .failed(message) = entry.status {
                Text("\(message)")
            }
        }
    }
}

struct ParkingStructuresWidgetListItem: View {
    let structure: ParkingStructure
    
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                HStack {
                    Text(structure.name)
                        .font(.headline)
                    Spacer()
                    Text("\(structure.currentCount)/\(structure.capacity)")
                }
            }
            ProgressView(value: Double(structure.currentCount) / Double(structure.capacity))
                .progressViewStyle(LinearProgressViewStyle())
        }
        .contentShape(Rectangle())
    }
}

#Preview(as: .systemMedium) {
    ParkingStructuresWidget()
} timeline: {
    ParkingStructuresWidgetEntry(
        systemId: "1",
        date: .now,
        parkingStructures: [
            .mock,
            .mock,
            .mock
        ],
        status: .succeeded
    )
}

