//
//  ParkingStructureWidget.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import WidgetKit
import SwiftUI
import ProjectInterShared

struct ParkingStructureWidgetEntryView: View {
    let entry: ParkingStructureWidgetEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let structure = entry.parkingStructure {
                Text(structure.name)
                    .bold()
                Spacer()
                Text("\(structure.currentCount)/\(structure.capacity)")
                ProgressView(value: Double(structure.currentCount) / Double(structure.capacity))
                    .progressViewStyle(LinearProgressViewStyle())

            }
            if case let .failed(message) = entry.status {
                Text("\(message)")
            }
        }
    }
}

#Preview(as: .systemSmall) {
    ParkingStructureWidget()
} timeline: {
    ParkingStructureWidgetEntry(
        systemId: "1",
        date: .now,
        parkingStructure: .mock,
        status: .succeeded
    )
}
