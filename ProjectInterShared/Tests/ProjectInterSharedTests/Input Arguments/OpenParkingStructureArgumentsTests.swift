//
//  OpenParkingStructureArgumentsTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Testing
import Foundation
@testable import ProjectInter

class OpenParkingStructureArgumentsTests {
    @Test func testConstructArgumentWithValidUrlConstructsArguments() async throws {
        let expected = OpenParkingStructureArguments(parkingStructureId: "1", systemId: "1")
        let url = URL(string: "interchange://x-callback-url/openParkingStructure?parkingStructureId=1&systemId=1")!
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
        let url = URL(string: "interchange://x-callback-url/openParkingStructure?systemId=1")!
        #expect(throws: DictionaryConstructableError.invalidArguments) {
            _ = try OpenParkingStructureArguments(url: url)
        }
    }
}
