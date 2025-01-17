//
//  SecondsFormatter.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.17.
//

struct ETAFormatter {
    /// Given the number of seconds remaining, turn it into a string for displaying ETA.
    static func formatSecondsRemaining(_ secondsRemaining: Double?) -> String {
        if let secondsRemaining = secondsRemaining {
            if secondsRemaining < 60 {
                return "Less than 1 minute"
            } else {
                let minutesRemaining = Int(secondsRemaining / 60)
                return "\(minutesRemaining) min"
            }
        }
        return "N/A"
    }
}
