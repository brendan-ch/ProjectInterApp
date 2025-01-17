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

class MapViewModelTests: NetworkDataModelTestsProtocol {
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
        etas: [
            .init(
                secondsRemaining: 20
            )
        ],
        id: "1",
        name: "Shuttle 1",
        route: Mock<Route>(
            color: "#ffffff",
            id: "1"
        )
    )
    
    var defaultMock: Mock<Query> {
        Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                routes: [
                    defaultRoute
                ],
                shuttles: [
                    defaultShuttle
                ],
                stops: [
                    .init(
                        coordinates: .init(
                            latitude: 1,
                            longitude: 1
                        ),
                        id: "1", name: "Chapman Court"
                    ),
                    .init(
                        coordinates: .init(
                            latitude: 2,
                            longitude: 2
                        ),
                        id: "2", name: "Panther Village"
                    )
                ]
            )
        )
    }
    
    var secondaryMock: Mock<Query> {
        Mock<ProjectInterTestMocks.Query>(
            system: .init(
                routes: [
                    .init(
                        color: "#000000",
                        id: "2",
                        polylineCoordinates: [
                            .init(
                                latitude: 3,
                                longitude: 3
                            ),
                            .init(
                                latitude: 4,
                                longitude: 4
                            )
                        ]
                    ),
                    .init(
                        color: "#111111",
                        id: "3",
                        polylineCoordinates: [
                            .init(
                                latitude: 5,
                                longitude: 5
                            ),
                            .init(
                                latitude: 6,
                                longitude: 6
                            )
                        ]
                    )
                ],
                shuttles: [
                    .init(
                        coordinates: Mock<Coordinates>(
                            latitude: 3,
                            longitude: 3
                        ),
                        etas: [
                            .init(
                                secondsRemaining: 20
                            )
                        ],
                        id: "2",
                        name: "Shuttle 2",
                        route: Mock<Route>(
                            color: "#000000",
                            id: "2"
                        )
                    ),
                    .init(
                        coordinates: Mock<Coordinates>(
                            latitude: 5,
                            longitude: 5
                        ),
                        etas: [
                            .init(
                                secondsRemaining: 20
                            )
                        ],
                        id: "3",
                        name: "Shuttle 3",
                        route: Mock<Route>(
                            color: "#111111",
                            id: "3"
                        )
                    )
                ],
                stops: [
                    .init(
                        coordinates: .init(
                            latitude: 3,
                            longitude: 3
                        ),
                        id: "3", name: "Schmid Gate"
                    )
                ]
            )
        )
    }
    
    func generateClientAndViewModelWithArguments() -> (MockApolloClient, MapViewModel, MapViewNetworkArguments) {
        let mockClient = MockApolloClient()
        
        let viewModel = MapViewModel(apolloClient: mockClient)
        let arguments = MapViewNetworkArguments(systemId: "1")
        
        return (mockClient, viewModel, arguments)
    }
    
    func assertViewModelDataForDefaultMock(viewModel: MapViewModel) {
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.shuttles.count == 1)
        #expect(viewModel.stops.count == 2)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: MapViewModel) {
        #expect(viewModel.routes.count == 2)
        #expect(viewModel.shuttles.count == 2)
        #expect(viewModel.stops.count == 1)
    }
    
    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = defaultMock
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(500))
        try? await Task.sleep(for: .milliseconds(200))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = defaultMock
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(500))
        try? await Task.sleep(for: .milliseconds(200))
        
        mockClient.mock = secondaryMock
        try? await Task.sleep(for: .milliseconds(400))
        
        assertViewModelDataForSecondaryMock(viewModel: viewModel)
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = defaultMock
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(500))
        try? await Task.sleep(for: .milliseconds(700))
        
        viewModel.stopRefreshingData()
        
        mockClient.mock = secondaryMock
        try? await Task.sleep(for: .milliseconds(400))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = defaultMock
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = nil

        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.isEmpty)
        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceStillPopulatesRoutesIfNoShuttles() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                routes: [
                    defaultRoute
                ]
            )
        )
        mockClient.mock = mock
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceStillPopulatesShuttlesIfNoRoutes() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                shuttles: [
                    defaultShuttle
                ]
            )
        )
        mockClient.mock = mock
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.shuttles.count == 1)
        #expect(viewModel.routes.isEmpty)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        let (_, viewModel, arguments) = generateClientAndViewModelWithArguments()
        viewModel.apolloClient = nil
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.isEmpty)
        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceUpdatesOrderedStopDataForStopIfExists() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        mockClient.mock = Mock<ProjectInterTestMocks.Query>(
            system: .init(
                stops: [
                    .init(
                        coordinates: .init(latitude: 1, longitude: 1),
                        id: "1",
                        name: "Chapman Court",
                        orderedStops: [
                            .init(
                                route: .init(
                                    id: "1"
                                )
                            )
                        ]
                    )
                ]
            )
        )
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.stops.first!.routeIds.count == 1)
        #expect(viewModel.stops.first!.routeIds.contains("1"))
    }
    
    @Test func refreshDataOnceOnlyAddsShuttlesWithEtaData() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        mockClient.mock = Mock<ProjectInterTestMocks.Query>(
            system: .init(
                shuttles: [
                    defaultShuttle,
                    .init(
                        coordinates: .init(
                            latitude: 2,
                            longitude: 2
                        ),
                        etas: nil,
                        id: "2",
                        name: "Shuttle 2",
                        route: Mock<Route>(
                            color: "#ffffff",
                            id: "1"
                        )
                    ),
                    .init(
                        coordinates: .init(
                            latitude: 3,
                            longitude: 3
                        ),
                        etas: [],
                        id: "3",
                        name: "Shuttle 3",
                        route: Mock<Route>(
                            color: "#ffffff",
                            id: "1"
                        )
                    )
                ]
            )
        )
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.shuttles.count == 1)
    }
}
