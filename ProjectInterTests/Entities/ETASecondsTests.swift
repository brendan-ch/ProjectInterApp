//
//  ETASecondsTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.11.25.
//

import Testing
@testable import ProjectInter

class ETASecondsTests {
    // MARK: - asLongString() tests (migrated from ETAFormatterTests)

    @Test func testAsLongStringForLateShuttle() {
        let eta = ETASeconds(-120)
        let formatted = eta.asLongString()
        #expect(formatted == "Running late")
    }

    @Test func testAsLongStringForUnderOneMinute() {
        let eta = ETASeconds(20)
        let formatted = eta.asLongString()
        #expect(formatted == "Under 1 minute")
    }

    @Test func testAsLongStringForAboveOneMinute() {
        let eta = ETASeconds(120)
        let formatted = eta.asLongString()
        #expect(formatted == "2 min")
    }

    // MARK: - convertToMinutesAsString() tests (for BinaryFloatingPoint logic)

    @Test func testConvertToMinutesAsStringForUnderOneMinute() {
        let eta = ETASeconds(30)
        let formatted = eta.convertToMinutesAsString()
        #expect(formatted == "<1")
    }

    @Test func testConvertToMinutesAsStringForExactlyOneMinute() {
        let eta = ETASeconds(60)
        let formatted = eta.convertToMinutesAsString()
        #expect(formatted == "1")
    }

    @Test func testConvertToMinutesAsStringForMultipleMinutes() {
        let eta = ETASeconds(300)
        let formatted = eta.convertToMinutesAsString()
        #expect(formatted == "5")
    }

    // MARK: - asShortString() tests

    @Test func testAsShortStringForUnderOneMinute() {
        let eta = ETASeconds(45)
        let formatted = eta.asShortString()
        #expect(formatted == "<1 min")
    }

    @Test func testAsShortStringForAboveOneMinute() {
        let eta = ETASeconds(180)
        let formatted = eta.asShortString()
        #expect(formatted == "3 min")
    }

    // MARK: - convertMultipleIntoShortString() tests

    @Test func testConvertMultipleIntoShortStringWithEmptyArray() {
        let formatted = ETASeconds.convertMultipleIntoShortString([])
        #expect(formatted == "")
    }

    @Test func testConvertMultipleIntoShortStringWithSingleETA() {
        let etas = [ETASeconds(120)]
        let formatted = ETASeconds.convertMultipleIntoShortString(etas)
        #expect(formatted == "2 min")
    }

    @Test func testConvertMultipleIntoShortStringWithMultipleETAs() {
        let etas = [ETASeconds(30), ETASeconds(120), ETASeconds(300)]
        let formatted = ETASeconds.convertMultipleIntoShortString(etas)
        #expect(formatted == "<1, 2, 5 min")
    }

    // MARK: - Comparable tests

    @Test func testComparable() {
        let eta1 = ETASeconds(60)
        let eta2 = ETASeconds(120)
        #expect(eta1 < eta2)
        #expect(eta2 > eta1)
    }

    // MARK: - Literal initialization tests

    @Test func testIntegerLiteralInitialization() {
        let eta: ETASeconds = 60
        #expect(eta.value == 60.0)
    }

    @Test func testFloatLiteralInitialization() {
        let eta: ETASeconds = 60.5
        #expect(eta.value == 60.5)
    }
}
