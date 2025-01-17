//
//  ETAFormatterTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.17.
//

import Testing
@testable import ProjectInter

class ETAFormatterTests {
    @Test func testFormatSecondsRemainingForNoData() {
        let formatted = ETAFormatter.formatSecondsRemaining(nil)
        #expect(formatted == "N/A")
    }
    
    @Test func testFormatSecondsRemainingForUnderOneMinute() {
        let formatted = ETAFormatter.formatSecondsRemaining(20)
        #expect(formatted == "Less than 1 minute")
    }
    
    @Test func testFormatsecondsRemainingForAboveOneMinute() {
        let formatted = ETAFormatter.formatSecondsRemaining(120)
        #expect(formatted == "2 min")
    }
}
