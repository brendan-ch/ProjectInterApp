//
//  ParkingStructureInfoContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.31.
//

import SwiftUI
import UniformTypeIdentifiers
import Charts

struct ParkingStructureInfoContentView: NetworkView {
    private let addressCopyTimeout = Duration.seconds(3)
    @State private var addressCopied = false
    @State private var showingNavigationAppDialog = false
    @State var viewModel = ViewModel()

    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionModel: GlobalIdSelectionModel
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    
    var networkArguments: ParkingStructureNetworkingArguments? {
        if let systemId = globalSystemsModel.selectedSystem?.id,
           let parkingStructureId = globalIdSelectionModel.selectedParkingStructureId {
            return .init(systemId: systemId, parkingStructureId: parkingStructureId)
        }
        return nil
    }

    var body: some View {
        RootSheetContentView {
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
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
        } content: {
            WithInitializationView(dataInitState: viewModel.dataInitState) {
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
                
                VStack {
                    Button {
                        showingNavigationAppDialog = true
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.turn.up.right")
                            Text("Directions")
                                .bold()
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .openNavigationDialog(viewModel.address, isPresented: $showingNavigationAppDialog)
                    
                    Button {
                        copyAddress()
                    } label: {
                        HStack {
                            Spacer()
                            Text(addressCopied ? "Copied!" : "Copy address")
                            Spacer()
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                }
                .padding()
                
                HStack {
                    Text("Compared to this day last week")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                if let insight = viewModel.parkingInsight {
                    HStack {
                        Text(insight)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                
                if let averages = viewModel.averages,
                   let capacity = viewModel.capacity,
                   let spotsAvailable = viewModel.spotsAvailable {
                    Group {
                        VStack(alignment: .leading, spacing: 16)  {
                            ParkingStructureInfoContentChart(
                                capacity: capacity,
                                spotsAvailable: spotsAvailable,
                                averages: averages,
                                intervalHours: ViewModel.intervalHours,
                                currentDayAverages: viewModel.currentDayAverages)
                        }
                    }
                    .frame(height: 240)
                    .padding()
                } else {
                    HStack {
                        Text("No historical data available. Check back later.")
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
        }
        .onAppear {
            restartDataUpdates()
            
            if let networkArguments = networkArguments {
                Task {
                    await viewModel.loadCurrentDayHistorical(networkArguments)
                }
            }
        }
        .onDisappear {
            stopDataUpdates()
        }
        .onChange(of: globalIdSelectionModel.selectedParkingStructureId) {
            restartDataUpdates()
        }
    }
    
    func copyAddress() {
        guard let address = viewModel.address else { return }
        UIPasteboard.general.setValue(address, forPasteboardType: UTType.text.identifier)
        
        addressCopied = true
        
        Task {
            try? await Task.sleep(for: addressCopyTimeout)
            addressCopied = false
        }
    }
}

struct ParkingStructureInfoContentChart: View {
    let capacity: Int
    let spotsAvailable: Int
    let averages: [ParkingAveragePerTimePeriod]
    let intervalHours: Int
    let currentDayAverages: [ParkingAveragePerTimePeriod]?
    
    var body: some View {
        Chart {
            ForEach(averages, id: \.from) { item in
                BarMark(
                    x: .value("Time", item.from ..< item.to),
                    y: .value("Average spots filled", capacity - item.averageSpotsAvailableRounded)
                )
                .foregroundStyle(by: .value("type", "This day last week"))
                .position(by: .value("type", "This day last week"))
            }
            
            if let currentDayAverages = currentDayAverages {
                ForEach(currentDayAverages, id: \.from) { item in
                    BarMark(
                        x: .value("Time", item.from ..< item.to),
                        y: .value("Average spots filled", capacity - item.averageSpotsAvailableRounded)
                    )
                    .foregroundStyle(by: .value("type", "Today"))
                    .position(by: .value("type", "Today"))
                }
            }
            
            RuleMark(y: .value("Spots filled", capacity - spotsAvailable))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 2]))
                .foregroundStyle(.pink)
        }
        .chartGesture { proxy in
            SpatialTapGesture().onEnded { value in
                if let (from, _) = proxy.value(at: value.location, as: (Date, Int).self),
                   let tappedIndex = averages.firstIndex(where: { $0.from == from }) {
                    print(tappedIndex)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .automatic, values: stride(from: 0, to: capacity, by: 100).map { $0 })
            
            AxisMarks(position: .leading, values: [capacity - spotsAvailable]) {
                AxisValueLabel("\(capacity - spotsAvailable)")
                    .foregroundStyle(.pink)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: intervalHours))
        }
        .chartForegroundStyleScale([
            "This day last week": .blue,
            "Today": .pink
        ])
        .chartLegend(.visible)
    }
}

#Preview {
    let viewModel = ParkingStructureInfoContentView.ViewModel.buildPlaceholder()
    
    ParkingStructureInfoContentView(viewModel: viewModel)
        .environment(GlobalIdSelectionModel())
        .environment(GlobalSystemsModel())
}
