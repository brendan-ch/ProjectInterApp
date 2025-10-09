//
//  OpenParkingStructureArgumentsTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Testing
import Foundation
@testable import ProjectInterShared

class OpenParkingStructureArgumentsTests {
    @Test func testConstructArgumentWithValidUrlConstructsArguments() async throws {
        let expected = OpenParkingStructureArguments(parkingStructureId: "1", systemId: "1")
        let url = URL(string: "interchange://x-callback-url\(OpenParkingStructureArguments.expectedUrlPath)?parkingStructureId=1&systemId=1")!
        let arguments = try OpenParkingStructureArguments(url: url)
        #expect(expected == arguments)
    }
    
    @Test func testConstructArgumentWithInvalidPathThrows() async throws {
        let url = URL(string: "interchange://x-callback-url/invalidPath?parkingStructureId=1&systemId=1")!
        #expect(throws: URLConstructableError.incorrectUrlHandler) {
            _ = try OpenParkingStructureArguments(url: url)
        }
    }
    
    @Test func testConstructArgumentWithInvalidParamsThrows() async throws {
        let url = URL(string: "interchange://x-callback-url\(OpenParkingStructureArguments.expectedUrlPath)?systemId=1")!
        #expect(throws: DictionaryConstructableError.invalidArguments) {
            _ = try OpenParkingStructureArguments(url: url)
        }
    }
    
    @Test func testConvertToUrlConvertsUrl() async throws {
        let base = OpenParkingStructureArguments(parkingStructureId: "1", systemId: "1")
        let url = base.toUrl()
        #expect(
            url?.absoluteString == "interchange://x-callback-url\(OpenParkingStructureArguments.expectedUrlPath)?parkingStructureId=1&systemId=1" ||
            url?.absoluteString == "interchange://x-callback-url\(OpenParkingStructureArguments.expectedUrlPath)?systemId=1&parkingStructureId=1"
        )
    }
}
