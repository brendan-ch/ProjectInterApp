//
//  ParkingStructuresWidgetEntryView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.07.
//

import WidgetKit
import SwiftUI

struct ParkingStructuresWidgetEntryView: View {
    let entry: ParkingStructuresWidgetEntry
    
    var body: some View {
        VStack(spacing: 16) {
            if let structures = entry.parkingStructures {
                ForEach(structures) { structure in
                    ParkingStructuresWidgetListItem(structure: structure)
                }
            }
            if case let .failed(message) = entry.status {
                Text("\(message)")
            }
        }
    }
}

struct ParkingStructuresWidgetListItem: View {
    let structure: ParkingStructuresWidgetEntry.ParkingStructure
    
    var link: URL? {
        // TODO: Construct an actual URL
        return URL(string: "interchange://x-callback-url/openParkingStructure?parkingStructureId=1&systemId=1")
    }
    
    var body: some View {
        if let link = link {
            Link(destination: link) {
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
    }
}

#Preview(as: .systemMedium) {
    ParkingStructuresWidget()
} timeline: {
    ParkingStructuresWidgetEntry(
        date: .now,
        parkingStructures: [
            .mock,
            .mock,
            .mock
        ],
        status: .succeeded
    )
}

