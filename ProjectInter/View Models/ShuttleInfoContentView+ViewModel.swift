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

// MARK: - View model implementation

extension ShuttleInfoContentView {
    typealias NetworkDataModelAlias = NetworkDataModel<ShuttleInfoNetworkArguments, GetShuttleInfoDataQuery>
    
    /// Backing view model for ``ShuttleInfoContentView``.
    @Observable
    class ViewModel: NetworkDataModelAlias, PlaceholderBuildable, Clearable {
        /// Name of the shuttle to display.
        private(set) var name: String? = nil
        
        private(set) var etaSecondsRemaining: Double? = nil
        private(set) var nameOfStop: String? = nil
        
        private(set) var stopId: String? = nil
        
        /// Text representing the ETA of the shuttle relative to the user's selected stop.
        var etaDisplay: String {
            if let nameOfStop = nameOfStop,
               let etaSecondsRemaining = etaSecondsRemaining {
                return "\(ETAFormatter.formatSecondsRemaining(etaSecondsRemaining)) to \(nameOfStop)"
            }
            
            return dataInitState == .initializing ? "" : "ETA currently not available"
        }
        
        var dataAvailable: Bool {
            name != nil
        }
        
        var etaListItems: [ShuttleInfoEtaListItem] = []
        
        private(set) var secondsThresholdForNotification: Int? = nil
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
        
        var availableNotificationOptions: [Int] {
            let allOptions = [2, 5, 10]
            guard let etaSecondsRemaining = etaSecondsRemaining else {
                return allOptions
            }
            
            let etaMinutes = etaSecondsRemaining / 60
            return allOptions.filter { minutes in
                Double(minutes) < etaMinutes
            }
        }
        
        override func convertNetworkArgumentsIntoQuery(_ arguments: ShuttleInfoNetworkArguments) -> GetShuttleInfoDataQuery {
            let systemId = arguments.systemId
            let stopId = arguments.stopId
            let shuttleId = arguments.shuttleId
            let deviceId = arguments.deviceId ?? ""
            
            self.stopId = stopId
            
            let notificationInput = NotificationInput(deviceId: deviceId, shuttleId: shuttleId, stopId: stopId)
            
            return GetShuttleInfoDataQuery(systemId: systemId, shuttleId: shuttleId, notificationInput: notificationInput)
        }
        
        override func processRefreshDataResult(_ result: Result<GetShuttleInfoDataQuery.Data, any Error>) {
            guard let data = try? result.get() else {
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
        
        func clearData() {
            resetDataInitState()
            name = nil
            etaSecondsRemaining = nil
            nameOfStop = nil
            stopId = nil
        }

        static func buildPlaceholder() -> Self {
            let model = Self(dataInitState: .succeeded)
            model.name = "Red Shuttle 17"
            model.nameOfStop = "Chapman Court"
            model.etaSecondsRemaining = 20
            
            model.etaListItems = [
                .init(stopName: "Chapman Court", secondsRemaining: 20, stopId: "0"),
                .init(stopName: "Schmid Gate", secondsRemaining: 125, stopId: "1"),
                .init(stopName: "Panther Village", secondsRemaining: 300, stopId: "2"),
                .init(stopName: "Chapman Grand", secondsRemaining: 1430, stopId: "3")
            ]
            
            return model
        }
    }
}
