//
//  ShuttleInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations

/// Information to pass into the shuttle info network request.
struct ShuttleInfoNetworkArguments {
    let systemId: String
    let stopId: String
    let shuttleId: String
    let deviceId: String?
}

/// Displays the ETA and seconds remaining for the currently open shuttle.
struct ShuttleInfoEtaListItem {
    var stopName: String?
    let secondsRemaining: Double
    var stopId: String?

    var estimatedTimeAwayDisplay: String {
        ETAFormatter.formatSecondsRemaining(secondsRemaining)
    }
}

extension ShuttleInfoEtaListItem {
    init(_ eta: GetShuttleInfoDataQuery.Data.System.Shuttle.Eta) {
        self.secondsRemaining = eta.secondsRemaining
        
        if let stop = eta.stop {
            self.stopName = stop.name
            self.stopId = stop.id
        }
    }
}

/// Backing view model for ``ShuttleInfoContentView``.
class ShuttleInfoContentViewModel: NetworkDataModelProtocol {
    typealias T = ShuttleInfoNetworkArguments
    
    /// Name of the shuttle to display.
    @Published var name: String = ""
    
    @Published var etaSecondsRemaining: Double? = nil
    @Published var nameOfStop: String? = nil
    
    /// Text representing the ETA of the shuttle relative to the user's selected stop.
    var etaDisplay: String {
        if let nameOfStop = nameOfStop,
           let etaSecondsRemaining = etaSecondsRemaining {
            return "\(ETAFormatter.formatSecondsRemaining(etaSecondsRemaining)) to \(nameOfStop)"
        }
        
        return "ETA currently not available"
    }
    
    @Published var etaListItems: [ShuttleInfoEtaListItem] = []
    
    @Published private(set) var secondsThresholdForNotification: Int? = nil
    var isNotificationScheduled: Bool {
        return secondsThresholdForNotification != nil
    }
    var notificationButtonText: String {
        if let secondsThresholdForNotification = secondsThresholdForNotification {
            let minutesRemaining = Int(secondsThresholdForNotification / 60)
            return "Cancel \(minutesRemaining)-minute notification"
        } else {
            return "Notify me when nearby"
        }
    }
    
    var apolloClient: ApolloClientProtocol?
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    var dataRefreshLoopTask: Task<Void, any Error>?

    func refreshDataOnce(arguments: ShuttleInfoNetworkArguments) async {
        let systemId = arguments.systemId
        let stopId = arguments.stopId
        let shuttleId = arguments.shuttleId
        let deviceId = arguments.deviceId
        
        await refreshData(systemId: systemId, stopId: stopId, shuttleId: shuttleId, deviceId: deviceId ?? "")
    }
    
    private func refreshData(systemId: String, stopId: String, shuttleId: String, deviceId: String) async {
        return await withCheckedContinuation { continuation in
            var continuationIsActive = true
            guard let apolloClient = apolloClient else {
                continuationIsActive = false
                continuation.resume()
                return
            }
            
            let notificationInput = NotificationInput(deviceId: deviceId, shuttleId: shuttleId, stopId: stopId)
            
            apolloClient.fetch(query: GetShuttleInfoDataQuery(systemId: systemId, shuttleId: shuttleId, notificationInput: notificationInput)) { result in
                defer {
                    continuationIsActive = false
                    continuation.resume()
                }
                
                if !continuationIsActive {
                    return
                }
                
                guard let data = try? result.get().data else {
                    return
                }
                guard let shuttle = data.system?.shuttle else {
                    return
                }
                
                self.name = shuttle.name
                
                if let etas = shuttle.etas {
                    self.etaListItems = []
                    for eta in etas {
                        guard let stop = eta.stop else { return }
                        if stop.id == stopId {
                            self.etaSecondsRemaining = eta.secondsRemaining
                            self.nameOfStop = stop.name
                        }
                        
                        self.etaListItems.append(ShuttleInfoEtaListItem(eta))
                    }
                    self.etaListItems.sort {
                        $0.secondsRemaining < $1.secondsRemaining
                    }
                }
                
                self.secondsThresholdForNotification = data.secondsThresholdForNotification
            }
        }
    }
}

