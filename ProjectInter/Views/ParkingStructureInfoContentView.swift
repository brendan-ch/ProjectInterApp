//
//  ParkingStructureInfoContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.31.
//

import SwiftUI
import Charts

let calendar = Calendar.current
let now = Date()

// Generated with Claude

struct ParkingStructureInfoContentView: NetworkView {
    @StateObject var viewModel = ParkingStructureInfoContentViewModel()

    @EnvironmentObject var globalIdSelectionModel: GlobalIdSelectionModel
    @EnvironmentObject var globalSystemsModel: GlobalSystemsModel
    
    var networkArguments: ParkingStructureNetworkingArguments? {
        if let systemId = globalSystemsModel.selectedSystem?.id,
           let parkingStructureId = globalIdSelectionModel.selectedParkingStructureId {
            return .init(systemId: systemId, parkingStructureId: parkingStructureId)
        }
        return nil
    }

    var body: some View {
        ScrollView(.vertical) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.name ?? "")
                        .font(.title2)
                        .bold()
                        .accessibilityLabel("Parking structure name")
                }
                Spacer()
                Button("Close") {
                    globalIdSelectionModel.selectedParkingStructureId = nil
                }
            }
            .padding()
            
            if let capacity = viewModel.capacity,
               let spotsAvailable = viewModel.spotsAvailable {
                let currentCount = capacity - spotsAvailable
                
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
            } else {
                Text("Parking data not available.")
            }

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
            
            if let averages = viewModel.averages,
               let capacity = viewModel.capacity {
                HStack {
                    Text("Historical Data")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                Group {
                    VStack(alignment: .leading, spacing: 16)  {
                        Chart(averages, id: \.from) { item in
                            BarMark(
                                x: .value("Time", item.from ..< item.to),
                                y: .value("Average spots filled", capacity - item.averageSpotsAvailableRounded)
                            )
                        }
                        .chartGesture { proxy in
                            SpatialTapGesture().onEnded { value in
                                if let (from, _) = proxy.value(at: value.location, as: (Date, Int).self),
                                   let tappedIndex = averages.firstIndex(where: { $0.from == from }) {
                                    print(tappedIndex)
                                }
                            }
                        }
                        
//                        Text("Right now, Anderson Structure is 30% more filled than this time from last week.")
                    }
                }
                .frame(height: 320)
                .padding()
            }
            
            
        }
        .onAppear {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
    }
}

#Preview {
    let viewModel = ParkingStructureInfoContentViewModelPlaceholderBuilder().build()
    
    ParkingStructureInfoContentView(viewModel: viewModel)
        .environmentObject(GlobalIdSelectionModel())
        .environmentObject(GlobalSystemsModel())
}
