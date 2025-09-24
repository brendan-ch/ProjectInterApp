//
//  Double.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.23.
//

extension BinaryFloatingPoint {
    func convertToMinutesAsString() -> String {
        let etaInSeconds = self
        let etaInMinutes = Int(etaInSeconds / 60)
        if etaInMinutes < 1 {
            return "<1"
        } else {
            return String(etaInMinutes)
        }

    }
}
