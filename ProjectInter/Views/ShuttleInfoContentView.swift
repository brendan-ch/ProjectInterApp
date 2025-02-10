//
//  ShuttleInfoContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

/// View which displays information about a single shuttle,
/// including ETA from the currently selected stop ID.
struct ShuttleInfoContentView: View {
    /// Backing view model.
    @StateObject var viewModel = ShuttleInfoContentViewModel()
    
    /// Source of truth for the currently selected shuttle ID.
    @EnvironmentObject var globalDataState: GlobalDataModel
    
    @EnvironmentObject var globalStopsState: GlobalStopsModel
    
    @EnvironmentObject var notificationSchedulingState: GlobalNotificationSchedulingModel
    
    @EnvironmentObject var customAppDelegate: CustomAppDelegate
    
    var shuttleInfoNetworkArguments: ShuttleInfoNetworkArguments? {
        guard let systemId = globalDataState.selectedSystem?.id,
              let shuttleId = globalDataState.selectedShuttleId,
              let stopId = globalStopsState.selectedStop?.id
            else { return nil }
        
        return ShuttleInfoNetworkArguments(
            systemId: systemId,
            stopId: stopId,
            shuttleId: shuttleId
        )
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title2)
                        .bold()
                    Text(viewModel.etaDisplay)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Close") {
                    globalDataState.selectedShuttleId = nil
                }
            }
            .padding()
            
            Button(action: {
                Task {
                    guard let stopId = globalStopsState.selectedStop?.id,
                          let shuttleId = globalDataState.selectedShuttleId,
                          let deviceId = customAppDelegate.notificationTokenString
                    else { return }
                    
                    let input = NotificationNetworkArguments(
                        deviceId: deviceId,
                        shuttleId: shuttleId,
                        stopId: stopId
                    )
                    do {
                        try await notificationSchedulingState.scheduleNotification(input)
                    } catch {
                        print(error)
                    }
                }
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "bell.badge")
                    Text("Notify me when nearby")
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
            
            // MARK: Upcoming stops
            // TODO: Display using the route's color
            // TODO: Gray out stops before the user's current stop
            VStack(spacing: 0) {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 2, height: 40)
                            .foregroundStyle(Color.blue)
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.blue)
                        Image(systemName: "bus.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                ForEach(viewModel.etaListItems, id: \.stopId) { etaListItem in
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 2, height: 40)
                                .foregroundStyle(Color.blue)
                            Circle()
                                .frame(width: 24, height: 12)
                                .foregroundStyle(Color.blue)
                        }
                        Text(etaListItem.stopName)
                        Spacer()
                        Text(etaListItem.estimatedTimeAwayDisplay)
                    }
                    .padding(.horizontal)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.background.secondary)
            )
            .padding(.horizontal)

        }
        .onAppear {
            if let client = globalDataState.apolloClient {
                viewModel.apolloClient = client
            }
            restartDataUpdatesIfArgumentsExist()
        }
        .onChange(of: globalDataState.selectedShuttleId) {
            restartDataUpdatesIfArgumentsExist()
        }
    }
    
    private func restartDataUpdatesIfArgumentsExist() {
        if let arguments = shuttleInfoNetworkArguments {
            viewModel.stopRefreshingData()
            viewModel.startRefreshingData(arguments: arguments)
        }
    }
}

#Preview {
    let builder = ShuttleInfoContentViewModelPlaceholderBuilder()
    let model = builder.build()
    
    return ShuttleInfoContentView(viewModel: model)
        .environmentObject(GlobalDataModel())
        .environmentObject(GlobalStopsModel())
        .environmentObject(GlobalNotificationSchedulingModel())
        .environmentObject(CustomAppDelegate())
}
