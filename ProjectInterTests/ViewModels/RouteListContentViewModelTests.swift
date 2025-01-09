//
//  RouteListContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.09.
//

import Testing
@testable import ProjectInter

class RouteListContentViewRouteTests {
    @Test func testEtaDisplayString() async throws {
        let route = RouteListContentViewRoute(
            id: "1",
            name: "Chapman Court",
            colorHex: "#000000",
            nextStopName: "Panther Village",
            etasInSeconds: [
                25, 125, 332
            ]
        )
        
        let expectedString = "<1, 2, 5 min"
        #expect(route.etaDisplayString == expectedString)
    }
    
    @Test func testEtaDisplayStringWithNoEtas() async throws {
        let route = RouteListContentViewRoute(
            id: "1",
            name: "Chapman Court",
            colorHex: "#000000",
            nextStopName: "Panther Village",
            etasInSeconds: []
        )
        
        let expectedString = "N/A"
        #expect(route.etaDisplayString == expectedString)
    }
}

class RouteListContentViewModelTests {
    
}
