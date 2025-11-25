//
//  ETASeconds.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.11.25.
//

struct ETASeconds: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Comparable, Equatable {
    static func < (lhs: ETASeconds, rhs: ETASeconds) -> Bool {
        lhs.value < rhs.value
    }
    
    let value: Double
    
    init(_ value: Double) {
        self.value = value
    }
    
    init(floatLiteral value: Double) {
        self.value = value
    }
    
    init(_ value: Int) {
        self.value = Double(value)
    }
    
    init(integerLiteral value: Int) {
        self.value = Double(value)
    }
    
    func asLongString() -> String {
        let secondsRemaining = value
        if secondsRemaining < 0 {
            return "Running late"
        } else if secondsRemaining < 60 {
            return "Under 1 minute"
        } else {
            let minutesRemaining = Int(secondsRemaining / 60)
            return "\(minutesRemaining) min"
        }
    }
    
    func asShortString() -> String {
        return convertToMinutesAsString() + " min"
    }
    
    func convertToMinutesAsString() -> String {
        let etaInSeconds = value
        let etaInMinutes = Int(etaInSeconds / 60)
        if etaInMinutes < 1 {
            return "<1"
        } else {
            return String(etaInMinutes)
        }
    }
    
    static func convertMultipleIntoShortString(_ etas: [ETASeconds]) -> String {
        if etas.isEmpty {
            return ""
        }
        
        let etasInMinutesAsStrings: [String] = etas.map { $0.convertToMinutesAsString() }
        
        var constructedString = etasInMinutesAsStrings.joined(separator: ", ")
        constructedString.append(" min")
        
        return constructedString
    }
}
