//
//  HiddenStopsModel.swift
//  ProjectInter
//
//  Created by Claude on 2026.03.29.
//

import Foundation
import ProjectInterShared
import ProjectInterLogging

/// Manages the set of stops that the user has chosen to hide, persisted per system in UserDefaults.
@Observable
class HiddenStopsModel {
    private(set) var userDefaults: UserDefaults?

    /// Raw dictionary stored in UserDefaults: [systemId: [stopId]]
    private var hiddenStopIdsBySystem: [String: [String]] {
        get {
            access(keyPath: \.hiddenStopIdsBySystem)
            return (userDefaults?.dictionary(forKey: UserDefaults.hiddenStopIdsKey) as? [String: [String]]) ?? [:]
        }
        set {
            withMutation(keyPath: \.hiddenStopIdsBySystem) {
                userDefaults?.setValue(newValue, forKey: UserDefaults.hiddenStopIdsKey)
            }
        }
    }

    init(userDefaults: UserDefaults? = .group) {
        self.userDefaults = userDefaults
    }

    /// Returns the set of hidden stop IDs for a given system.
    func hiddenStopIds(forSystem systemId: String) -> Set<String> {
        Set(hiddenStopIdsBySystem[systemId] ?? [])
    }

    func isStopHidden(_ stopId: String, inSystem systemId: String) -> Bool {
        hiddenStopIds(forSystem: systemId).contains(stopId)
    }

    func setStopHidden(_ stopId: String, inSystem systemId: String, hidden: Bool) {
        var dict = hiddenStopIdsBySystem
        var ids = Set(dict[systemId] ?? [])

        if hidden {
            ids.insert(stopId)
        } else {
            ids.remove(stopId)
        }

        dict[systemId] = Array(ids)
        hiddenStopIdsBySystem = dict

        Loggers.shared.globalStateEventsLogger.notice(
            "Stop \(stopId) in system \(systemId) hidden: \(hidden)"
        )
    }

    func toggleStopHidden(_ stopId: String, inSystem systemId: String) {
        let currentlyHidden = isStopHidden(stopId, inSystem: systemId)
        setStopHidden(stopId, inSystem: systemId, hidden: !currentlyHidden)
    }
}
