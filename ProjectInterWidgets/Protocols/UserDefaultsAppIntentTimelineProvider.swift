//
//  UserDefaultsTimelineProvider.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.29.
//

import Foundation
import WidgetKit
import ProjectInterShared

protocol UserDefaultsAppIntentTimelineProvider: AppIntentTimelineProvider {
    var userDefaults: UserDefaults? { get }
    
    init(userDefaults: UserDefaults?)
    
    var setupCompleted: Bool { get }
}

extension UserDefaultsAppIntentTimelineProvider {
    var setupCompleted: Bool {
        guard let setupCompleted = userDefaults?.bool(forKey: UserDefaults.setupCompletedKey) else {
            return false
        }
        return setupCompleted
    }
}

