//
//  ParkingStructureInfoContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.31.
//

import SwiftUI
import Charts

struct ParkingAveragePerTimePeriod {
    let from: Date
    let to: Date
    let averageSpotsAvailable: Float
    var averageSpotsAvailableRounded: Int {
        Int(self.averageSpotsAvailable.rounded())
    }
}

let calendar = Calendar.current
let now = Date()

// Generated with Claude
let data: [ParkingAveragePerTimePeriod] = [
    .init(
        from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
        to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
        averageSpotsAvailable: 50
    ),
    .init(
        from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
        to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
        averageSpotsAvailable: 28
    ),
    .init(
        from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
        to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!,
        averageSpotsAvailable: 15
    ),
    .init(
        from: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!,
        to: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now)!,
        averageSpotsAvailable: 17
    ),
    .init(
        from: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now)!,
        to: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!,
        averageSpotsAvailable: 21
    ),
    .init(
        from: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!,
        to: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!,
        averageSpotsAvailable: 47
    ),
    .init(
        from: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!,
        to: calendar.date(bySettingHour: 22, minute: 0, second: 0, of: now)!,
        averageSpotsAvailable: 76
    )
]

struct ParkingStructureInfoContentView: View {
    let currentCount = 50
    let capacity = 100
    
    var body: some View {
        ScrollView(.vertical) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Anderson Structure")
                        .font(.title2)
                        .bold()
                        .accessibilityLabel("Parking structure name")
                }
                Spacer()
                Button("Close") {
                }
            }
            .padding()
            
            VStack {
                HStack {
                    Text("\(capacity - currentCount) available")
                    Spacer()
                    Text("\(currentCount)/\(capacity)")
                }
                ProgressView(value: Double(currentCount) / Double(capacity))
                    .progressViewStyle(LinearProgressViewStyle())
            }
            .padding(.horizontal)

            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Text("Directions")
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
            
            HStack {
                Text("Historical Data")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            Group {
                VStack(alignment: .leading, spacing: 16)  {
                    Chart(data, id: \.from) { item in
                        BarMark(
                            x: .value("Time", item.from ..< item.to),
                            y: .value("Average spots filled", capacity - item.averageSpotsAvailableRounded)
                        )
                    }
                    .chartGesture { proxy in
                        SpatialTapGesture().onEnded { value in
                            if let (from, _) = proxy.value(at: value.location, as: (Date, Int).self),
                               let tappedIndex = data.firstIndex(where: { $0.from == from }) {
                                print(tappedIndex)
                            }
                        }
                    }
                    
                    Text("Right now, Anderson Structure is 30% more filled than this time from last week.")
                }
            }
            .frame(height: 320)
            .padding()
            
        }
    }
}

#Preview {
    ParkingStructureInfoContentView()
}
