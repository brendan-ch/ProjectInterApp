//
//  TimelineEntryStatus.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import Foundation

public enum TimelineEntryStatus: Equatable {
    public static func == (lhs: TimelineEntryStatus, rhs: TimelineEntryStatus) -> Bool {
        switch (lhs, rhs) {
        case (.succeeded, .succeeded):
            return true
        case (.failed, failed):
            return true
        default:
            return false
        }
    }
    
    case succeeded
    case failed(error: String)
}
