//
//  ShuttleInfoContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

/// View which displays information about a single shuttle,
/// including ETA from the currently selected stop ID.
struct ShuttleInfoContentView: NetworkView {
    /// Backing view model.
    @StateObject var viewModel = ShuttleInfoContentViewModel()
    
    /// Source of truth for the currently selected shuttle ID.
    @EnvironmentObject var globalIdSelectionModel: GlobalIdSelectionModel
    @EnvironmentObject var globalSystemsModel: GlobalSystemsModel
    
    @EnvironmentObject var globalStopsModel: GlobalStopsModel
    
    @EnvironmentObject var notificationSchedulingState: GlobalNotificationSchedulingModel
    
    @EnvironmentObject var customAppDelegate: CustomAppDelegate
    
    @State var showingNotificationPermissionsNotGrantedAlert = false
    @State var showingNotificationConfirmationDialog = false
    
    var isNotificationScheduled: Bool {
        return viewModel.isNotificationScheduled
    }
    
    var networkArguments: ShuttleInfoNetworkArguments? {
        guard let systemId = globalSystemsModel.selectedSystem?.id,
              let shuttleId = globalIdSelectionModel.selectedShuttleId,
              let stopId = globalStopsModel.selectedStop?.id
            else { return nil }
        
        return ShuttleInfoNetworkArguments(
            systemId: systemId,
            stopId: stopId,
            shuttleId: shuttleId,
            deviceId: customAppDelegate.notificationTokenString
        )
    }
    
    var hasNoNotificationOptions: Bool {
        viewModel.availableNotificationOptions.isEmpty
    }
    var buttonForegroundStyle: Color? {
        if hasNoNotificationOptions {
            return nil  // Let SwiftUI handle disabled styling
        }
        return isNotificationScheduled ? .red : .blue
    }
    
    var body: some View {
        WithInitializationView(dataInitState: viewModel.dataInitState) {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(viewModel.name)
                            .font(.title2)
                            .bold()
                            .accessibilityLabel("Shuttle name")
                        Text(viewModel.etaDisplay)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Close") {
                        globalIdSelectionModel.selectedShuttleId = nil
                    }
                }
                .padding()
                
                Button(action: {
                    if customAppDelegate.notificationTokenString == nil {
                        showingNotificationPermissionsNotGrantedAlert = true
                        return
                    } else if isNotificationScheduled {
                        Task {
                            await cancelNotification()
                        }
                    } else {
                        showingNotificationConfirmationDialog = true
                    }
                    
                }) {
                    HStack {
                        Spacer()
                        if isNotificationScheduled {
                            Image(systemName: "multiply")
                        } else {
                            Image(systemName: "bell.badge")
                        }
                        Text(viewModel.notificationButtonText)
                        Spacer()
                    }
                }
                .disabled(hasNoNotificationOptions)
                .buttonStyle(.bordered)
                .conditionalForegroundStyle(buttonForegroundStyle)
                .controlSize(.large)
                .padding()
                .alert("Turn on notifications", isPresented: $showingNotificationPermissionsNotGrantedAlert) {
                    Button("Dismiss", role: .cancel) { }
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                } message: {
                    Text("To schedule a notification, turn on app notifications.")
                }
                .confirmationDialog("Select a timeframe", isPresented: $showingNotificationConfirmationDialog, titleVisibility: .visible) {
                    ForEach(viewModel.availableNotificationOptions, id: \.self) { minutes in
                        Button("\(minutes) minutes") {
                            Task {
                                if !isNotificationScheduled {
                                    let secondsThreshold = (minutes * 60)
                                    await scheduleNotification(secondsThreshold: secondsThreshold)
                                }
                            }
                        }
                    }
                }
                
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
                                    .frame(minWidth: 2, idealWidth: 2, maxWidth: 2, minHeight: 40, idealHeight: 40, maxHeight: .infinity)
                                    .foregroundStyle(Color.blue)
                                Circle()
                                    .frame(width: 24, height: 12)
                                    .foregroundStyle(Color.blue)
                            }
                            Text(etaListItem.stopName ?? "N/A")
                            Spacer()
                            Text(etaListItem.estimatedTimeAwayDisplay)
                                .multilineTextAlignment(.trailing)
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
        }
        .onAppear {
            restartDataUpdates()
        }
        .onChange(of: globalIdSelectionModel.selectedShuttleId) {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
    }
    
    private func generateNotificationNetworkArguments() -> NotificationNetworkArguments? {
        guard let stopId = globalStopsModel.selectedStop?.id,
              let shuttleId = globalIdSelectionModel.selectedShuttleId,
              let deviceId = customAppDelegate.notificationTokenString
        else { return nil }
        
        let input = NotificationNetworkArguments(
            deviceId: deviceId,
            shuttleId: shuttleId,
            stopId: stopId,
            secondsThreshold: nil
        )
        return input
    }
    
    private func scheduleNotification(secondsThreshold: Int) async {
        guard var input = generateNotificationNetworkArguments() else { return }
        input.secondsThreshold = secondsThreshold
        do {
            try await notificationSchedulingState.scheduleNotification(input)
            restartDataUpdates()
        } catch {
            print(error)
        }
    }
    
    private func cancelNotification() async {
        guard let input = generateNotificationNetworkArguments() else { return }
        do {
            try await notificationSchedulingState.cancelNotification(input)
            restartDataUpdates()
        } catch {
            print(error)
        }
    }
}

#Preview {
    let builder = ShuttleInfoContentViewModelPlaceholderBuilder()
    let model = builder.build()
    
    return ShuttleInfoContentView(viewModel: model)
        .environmentObject(GlobalSystemsModel())
        .environmentObject(GlobalIdSelectionModel())
        .environmentObject(GlobalStopsModel())
        .environmentObject(GlobalNotificationSchedulingModel())
        .environmentObject(CustomAppDelegate())
}
