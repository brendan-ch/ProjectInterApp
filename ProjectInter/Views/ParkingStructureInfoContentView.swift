//
//  ParkingStructureInfoContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.31.
//

import SwiftUI
import Charts

struct ParkingAveragePerTimePeriod {
    var timePeriod: String
    var filledPercentage: Double
}

let data: [ParkingAveragePerTimePeriod] = [
    .init(timePeriod: "8-10 AM", filledPercentage: 50),
    .init(timePeriod: "10 AM-12 PM", filledPercentage: 72),
    .init(timePeriod: "12-2 PM", filledPercentage: 85),
    .init(timePeriod: "2-4 PM", filledPercentage: 83),
    .init(timePeriod: "4-6 PM", filledPercentage: 79),
    .init(timePeriod: "6-8 PM", filledPercentage: 53),
    .init(timePeriod: "8-10 PM", filledPercentage: 24)
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
                    Chart(data, id: \.timePeriod) { item in
                        BarMark(
                            x: .value("Time", item.timePeriod),
                            y: .value("Filled %", item.filledPercentage)
                        )
                    }
                    .chartGesture { proxy in
                        SpatialTapGesture().onEnded { value in
                            if let (timePeriod, _) = proxy.value(at: value.location, as: (String, Int).self),
                               let tappedIndex = data.firstIndex(where: { $0.timePeriod == timePeriod }) {
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
