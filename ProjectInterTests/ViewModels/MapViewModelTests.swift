//
//  MapViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.13.
//

import Testing
@testable import ProjectInter
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

// MARK: - Mock data
class MapViewModelTestsMockData {
    static let defaultRoute = Mock<ProjectInterTestMocks.Route>(
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

    static let defaultShuttle = Mock<ProjectInterTestMocks.Shuttle>(
        coordinates: Mock<Coordinates>(
            latitude: 1,
            longitude: 1
        ),
        id: "1",
        name: "Shuttle 1",
        orientationInDegrees: 90.00,
        route: Mock<Route>(
            color: "#ffffff",
            id: "1"
        )
    )

    static var defaultMock: Mock<Query> {
        Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                parkingSystem: .init(
                    parkingStructures: [
                        .init(
                            coordinates: .init(
                                latitude: 33.7945513,
                                longitude: -117.8518707
                            ),
                            id: "1",
                            name: "Anderson Structure"
                        ),
                        .init(
                            coordinates: .init(
                                latitude: 33.792937,
                                longitude: -117.854782
                            ),
                            id: "2",
                            name: "Barrera"
                        )
                    ]
                ),
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

    static var secondaryMock: Mock<Query> {
        Mock<ProjectInterTestMocks.Query>(
            system: .init(
                parkingSystem: nil,
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
                        id: "2",
                        name: "Shuttle 2",
                        orientationInDegrees: 60.92,
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
                        id: "3",
                        name: "Shuttle 3",
                        orientationInDegrees: 70.25,
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
}

// MARK: - Data model tests

class MapViewRouteTests {
    @Test func mapViewRouteConstructsRouteFromApolloData() {
        let data = GetMapDataQuery.Data.from(MapViewModelTestsMockData.defaultMock)
        let routes = data.system!.routes!
        
        let constructedRoutes = routes.map(MapViewRoute.init)
        for i in 0..<constructedRoutes.count {
            #expect(routes[i].color == constructedRoutes[i].colorHex)
            #expect(routes[i].id == constructedRoutes[i].id)
            
            for j in 0..<constructedRoutes[i].polylineCoordinates.count {
                #expect(constructedRoutes[i].polylineCoordinates[j].latitude == routes[i].polylineCoordinates[j].latitude)
                #expect(constructedRoutes[i].polylineCoordinates[j].latitude == routes[i].polylineCoordinates[j].longitude)
            }
        }
    }
}

class MapViewStopTests {
    @Test func mapViewStopConstructsStopFromApolloData() {
        let data = GetMapDataQuery.Data.from(MapViewModelTestsMockData.defaultMock)
        let stops = data.system!.stops!
        
        let constructedStops = stops.map(MapViewStop.init)
        for i in 0..<constructedStops.count {
            #expect(stops[i].id == constructedStops[i].id)
            #expect(stops[i].name == constructedStops[i].name)
            #expect(stops[i].coordinates.latitude == constructedStops[i].coordinates.latitude)
            #expect(stops[i].coordinates.longitude == constructedStops[i].coordinates.longitude)
            
            if let orderedStops = stops[i].orderedStops {
                for orderedStop in orderedStops {
                    #expect(constructedStops[i].routeIds.contains(orderedStop.routeId))
                }
            }
        }
    }
}

class MapViewShuttleTests {
    @Test func mapViewShuttleConstructsShuttleFromApolloData() {
        let data = GetMapDataQuery.Data.from(MapViewModelTestsMockData.defaultMock)
        let shuttles = data.system!.shuttles!
        
        let constructedShuttles = shuttles.map(MapViewShuttle.init)
        for i in 0..<constructedShuttles.count {
            #expect(shuttles[i].id == constructedShuttles[i].id)
            #expect(shuttles[i].name == constructedShuttles[i].name)
            #expect(shuttles[i].coordinates.latitude == constructedShuttles[i].coordinates.latitude)
            #expect(shuttles[i].coordinates.longitude == constructedShuttles[i].coordinates.longitude)
            
            #expect(shuttles[i].route?.id == constructedShuttles[i].routeId)
            #expect(shuttles[i].route?.color == constructedShuttles[i].routeColorHex)
            #expect(shuttles[i].orientationInDegrees == constructedShuttles[i].orientationInDegrees)
        }
    }
}

class MapViewParkingStructureTests {
    @Test func mapViewParkingStructureConstructsStructureFromApolloData() {
        let data = GetMapDataQuery.Data.from(MapViewModelTestsMockData.defaultMock)
        let parkingStructures = data.system!.parkingSystem!.parkingStructures!
        
        let constructedStructures = parkingStructures.map(MapViewParkingStructure.init)
        for i in 0..<parkingStructures.count {
            #expect(parkingStructures[i].id == constructedStructures[i].id)
            #expect(parkingStructures[i].coordinates.latitude == constructedStructures[i].coordinates.latitude)
            #expect(parkingStructures[i].coordinates.longitude == constructedStructures[i].coordinates.longitude)
            #expect(parkingStructures[i].name == constructedStructures[i].name)
        }
    }
}

// MARK: - View model tests

class MapViewModelTests: NetworkDataModelTestsProtocol {
    let networkArguments = MapViewNetworkArguments(systemId: "1")
    let defaultMock = MapViewModelTestsMockData.defaultMock
    let secondaryMock = MapViewModelTestsMockData.secondaryMock
    
    func assertViewModelDataForDefaultMock(viewModel: MapViewModel) {
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.shuttles.count == 1)
        #expect(viewModel.stops.count == 2)
        #expect(viewModel.parkingStructures.count == 2)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: MapViewModel) {
        #expect(viewModel.routes.count == 2)
        #expect(viewModel.shuttles.count == 2)
        #expect(viewModel.stops.count == 1)
        #expect(viewModel.parkingStructures.count == 0)
    }
    
    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        await autoTest_startRefreshingDataRefreshesDataOnFirstCall()
    }
    
    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        await autoTest_startRefreshingDataRefreshesDataMultipleTimes()
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        await autoTest_stopRefreshingDataStopsDataUpdatesAfterCompletion()
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        await autoTest_refreshDataOnceUpdatesData()
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
//        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
//        mockClient.queryMock = nil
//
//        await viewModel.refreshDataOnce(arguments: arguments)
//        
//        #expect(viewModel.routes.isEmpty)
//        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceStillPopulatesRoutesIfNoShuttles() async {
//        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
//        let mock = Mock<ProjectInterTestMocks.Query>(
//            system: Mock<ProjectInterTestMocks.System>(
//                routes: [
//                    MapViewModelTestsMockData.defaultRoute
//                ]
//            )
//        )
//        mockClient.queryMock = mock
//        
//        await viewModel.refreshDataOnce(arguments: arguments)
//        
//        #expect(viewModel.routes.count == 1)
//        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceStillPopulatesShuttlesIfNoRoutes() async {
//        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
//        let mock = Mock<ProjectInterTestMocks.Query>(
//            system: Mock<ProjectInterTestMocks.System>(
//                shuttles: [
//                    MapViewModelTestsMockData.defaultShuttle
//                ]
//            )
//        )
//        mockClient.queryMock = mock
//        
//        await viewModel.refreshDataOnce(arguments: arguments)
//        
//        #expect(viewModel.shuttles.count == 1)
//        #expect(viewModel.routes.isEmpty)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
//        let (_, viewModel, arguments) = generateClientAndViewModelWithArguments()
//        viewModel.apolloClient = nil
//        
//        await viewModel.refreshDataOnce(arguments: arguments)
//        
//        #expect(viewModel.routes.isEmpty)
//        #expect(viewModel.shuttles.isEmpty)
    }
    
    @Test func refreshDataOnceUpdatesOrderedStopDataForStopIfExists() async {
//        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
//        
//        mockClient.queryMock = Mock<ProjectInterTestMocks.Query>(
//            system: .init(
//                stops: [
//                    .init(
//                        coordinates: .init(latitude: 1, longitude: 1),
//                        id: "1",
//                        name: "Chapman Court",
//                        orderedStops: [
//                            .init(
//                                routeId: "1"
//                            )
//                        ]
//                    )
//                ]
//            )
//        )
//        
//        await viewModel.refreshDataOnce(arguments: arguments)
//        
//        #expect(viewModel.stops.first!.routeIds.count == 1)
//        #expect(viewModel.stops.first!.routeIds.contains("1"))
    }
}
