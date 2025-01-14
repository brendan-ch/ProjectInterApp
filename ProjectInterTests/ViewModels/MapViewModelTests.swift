//
//  MapViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.13.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

class MapViewModelTests {
    let defaultRoute = Mock<ProjectInterTestMocks.Route>(
        color: "#ffffff",
        id: "1",
        polylineCoordinates: [
            Mock<Coordinates>(
                latitude: 1,
                longitude: 1
            ),
            Mock<Coordinates>(
                latitude: 2,
                longitude: 2
            )
        ]
    )
            
    
    let defaultShuttle = Mock<ProjectInterTestMocks.Shuttle>(
        coordinates: Mock<Coordinates>(
            latitude: 1,
            longitude: 1
        ),
        id: "1",
        name: "Shuttle 1", route: Mock<Route>(
            color: "#ffffff",
            id: "1"
        )
    )
    
    @Test func refreshDataOnceRefreshesData() async {
        let mockClient = MockApolloClient()
        
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                routes: [
                    defaultRoute
                ],
                shuttles: [
                    defaultShuttle
                ]
            )
        )
        mockClient.mock = mock
        
        let viewModel = MapViewModel(apolloClient: mockClient)
        let arguments = MapViewNetworkArguments(systemId: "1")
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.shuttles.count == 1)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let mockClient = MockApolloClient()
        mockClient.mock = nil
        
        let viewModel = MapViewModel(apolloClient: mockClient)
        let arguments = MapViewNetworkArguments(systemId: "1")
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.isEmpty)
        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceStillPopulatesRoutesIfNoShuttles() async {
        let mockClient = MockApolloClient()
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                routes: [
                    defaultRoute
                ]
            )
        )
        mockClient.mock = mock
        
        let viewModel = MapViewModel(apolloClient: mockClient)
        let arguments = MapViewNetworkArguments(systemId: "1")
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceStillPopulatesShuttlesIfNoRoutes() async {
        let mockClient = MockApolloClient()
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                shuttles: [
                    defaultShuttle
                ]
            )
        )
        mockClient.mock = mock
        
        let viewModel = MapViewModel(apolloClient: mockClient)
        let arguments = MapViewNetworkArguments(systemId: "1")
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.shuttles.count == 1)
        #expect(viewModel.routes.isEmpty)
    }
}
