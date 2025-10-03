//
//  OpenRouteArgumentsTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation
import Testing
@testable import ProjectInter

class OpenRouteArgumentsTests {
    @Test func testConstructArgumentWithValidUrlConstructsArguments() async throws {
        let expected = OpenRouteArguments(routeId: "1", systemId: "1", stopId: "1")
        let url = URL(string: "interchange://x-callback-url/openRoute?stopId=1&routeId=1&systemId=1")!
        let arguments = try OpenRouteArguments(url: url)
        #expect(expected == arguments)
    }
    
    @Test func testConstructArgumentWithInvalidPathThrows() async throws {
        let url = URL(string: "interchange://x-callback-url/invalidPath?stopId=1&routeId=1&systemId=1")!
        #expect(throws: URLConstructableError.incorrectUrlHandler) {
            _ = try OpenRouteArguments(url: url)
        }
    }
    
    @Test func testConstructArgumentWithInvalidParamsThrows() async throws {
        let url = URL(string: "interchange://x-callback-url/openRoute?routeId=1&systemId=1")!
        #expect(throws: DictionaryConstructableError.invalidArguments) {
            _ = try OpenRouteArguments(url: url)
        }
    }
}
