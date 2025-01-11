//
//  RouteListContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.09.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

class RouteListContentViewRouteTests {
    func generateRouteObject() -> RouteListContentViewRoute {
        return RouteListContentViewRoute(
            id: "1",
            name: "Chapman Court",
            colorHex: "#000000",
            nextStopName: "Panther Village"
        )
    }
    
    @Test func etaDisplaysCorrectlyWithEtas() async throws {
        var route = generateRouteObject()
        route.addEta(25)
        route.addEta(125)
        route.addEta(332)
        
        let expectedString = "<1, 2, 5 min"
        #expect(route.etaDisplayString == expectedString)
    }
    
    @Test func etaDisplaysCorrectlyWithNoEtas() async throws {
        let route = generateRouteObject()
        
        let expectedString = "N/A"
        #expect(route.etaDisplayString == expectedString)
    }
    
    @Test func addEtaSortsEtasInAscendingOrder() async throws {
        var route = generateRouteObject()
        route.addEta(125)
        route.addEta(25)
        #expect(route.etasInSeconds == [25, 125])
    }
    
    @Test func clearEtasClearsEtas() async throws {
        var route = generateRouteObject()
        route.addEta(125)
        route.addEta(25)
        route.clearEtas()
        #expect(route.etasInSeconds.isEmpty)
    }
}

class RouteListContentViewModelTests {
    @Test func refreshDataUpdatesStateData() async throws {
        // Arrange
        let mockClient = MockApolloClient()
        let mock = Mock<ProjectInterTestMocks.Query>(
            systems: [
                Mock<ProjectInterTestMocks.System>(
                    id: "1",
                    name: "Chapman University",
                    stop: Mock<ProjectInterTestMocks.Stop>(
                        id: "1",
                        name: "Chapman Court",
                        orderedStops: [
                            Mock<ProjectInterTestMocks.OrderedStop>(
                                nextStop: Mock<ProjectInterTestMocks.OrderedStop>(
                                    stop: Mock<ProjectInterTestMocks.Stop>(
                                        name: "Panther Village"
                                    )
                                ), route: Mock<ProjectInterTestMocks.Route>(
                                    color: "#db2316",
                                    id: "1",
                                    name: "Red Route",
                                    shuttles: [
                                        Mock<ProjectInterTestMocks.Shuttle>(
                                            eta: Mock<ProjectInterTestMocks.ETA>(
                                                secondsRemaining: 20
                                            )
                                        ),
                                        Mock<ProjectInterTestMocks.Shuttle>(
                                            eta: Mock<ProjectInterTestMocks.ETA>(
                                                secondsRemaining: 100
                                            )
                                        )
                                    ]
                                )
                            )
                        ]
                    )
                )
            ]
        )
        mockClient.mock = mock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        let arguments = RouteListNetworkArguments(systemId: "1", stopId: "1")
        
        func callback() {
            // Assert
            #expect(viewModel.routes.count == 1)
        }
        
        // Act
        viewModel.refreshDataOnce(arguments: arguments, onSuccess: callback)
    }
}
