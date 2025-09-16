//
//  ShuttleInfoContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.13.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks
import ProjectInterOperations

class ShuttleInfoContentViewModelMockData {
    static let defaultMock = Mock<Query>(
        secondsThresholdForNotification: 239,
        system: .init(
            shuttle: .init(
                etas: [
                    .init(
                        secondsRemaining: 125,
                        stop: .init(
                            id: "1",
                            name: "Stop 1"
                        )
                    ),
                    .init(
                        secondsRemaining: 20,
                        stop: .init(
                            id: "2",
                            name: "Stop 2"
                        )
                    ),
                ],
                name: "Shuttle 1"
            )
        )
    )
    
    static let secondaryMock = Mock<Query>(
        secondsThresholdForNotification: nil,
        system: .init(
            shuttle: .init(
                etas: [
                    .init(
                        secondsRemaining: 306,
                        stop: .init(
                            id: "1",
                            name: "Stop 1"
                        )
                    ),
                    .init(
                        secondsRemaining: 205,
                        stop: .init(
                            id: "2",
                            name: "Stop 2"
                        )
                    ),
                ],
                name: "Shuttle 2"
            )
        )
    )

}

class ShuttleInfoEtaListItemTests {
    @Test func apolloInitializerInitializesData() {
        let data = GetShuttleInfoDataQuery.Data.from(ShuttleInfoContentViewModelMockData.defaultMock)
        let etas = data.system!.shuttle!.etas!
        
        let constructedEtas = etas.map(ShuttleInfoEtaListItem.init)
        for i in 0..<constructedEtas.count {
            #expect(etas[i].secondsRemaining == constructedEtas[i].secondsRemaining)
            #expect(etas[i].stop?.name == constructedEtas[i].stopName)
            #expect(etas[i].stop?.id == constructedEtas[i].stopId)
        }
    }
}

class ShuttleInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let networkArguments = ShuttleInfoNetworkArguments(systemId: "1", stopId: "1", shuttleId: "1", deviceId: "1")
    let defaultMock = ShuttleInfoContentViewModelMockData.defaultMock
    let secondaryMock = ShuttleInfoContentViewModelMockData.secondaryMock
    
    func assertViewModelDataForDefaultMock(viewModel: ShuttleInfoContentView.ViewModel) {
        #expect(viewModel.name == "Shuttle 1")
        #expect(viewModel.etaDisplay == "2 min to Stop 1")
        
        // Check sorting of items
        #expect(viewModel.etaListItems.count == 2)
        #expect(viewModel.etaListItems[0].secondsRemaining == 20)
        #expect(viewModel.etaListItems[1].secondsRemaining == 125)
        
        #expect(viewModel.isNotificationScheduled)
        #expect(viewModel.secondsThresholdForNotification == 239)
        
        #expect(viewModel.notificationButtonText == "Cancel 3-minute notification")
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ShuttleInfoContentView.ViewModel) {
        #expect(viewModel.name == "Shuttle 2")
        #expect(viewModel.etaDisplay == "5 min to Stop 1")
        
        
        // Check sorting of items
        #expect(viewModel.etaListItems.count == 2)
        #expect(viewModel.etaListItems[0].secondsRemaining == 205)
        #expect(viewModel.etaListItems[1].secondsRemaining == 306)
        
        #expect(!viewModel.isNotificationScheduled)
        #expect(viewModel.secondsThresholdForNotification == nil)
        
        #expect(viewModel.notificationButtonText == "Notify me when nearby")
    }
    
    func assertViewModelDataForEmptyMock(viewModel: ShuttleInfoContentView.ViewModel) {
        #expect(viewModel.name == nil)
        #expect(viewModel.etaDisplay == "ETA currently not available")
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
    
    @Test func refreshDataOnceUpdatesEtaCorrectlyIfUnderOneMin() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        mockClient.queryMock = Mock<Query>(
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: 20,
                            stop: .init(
                                id: "1",
                                name: "Stop 1"
                            )
                        )
                    ],
                    name: "Shuttle 1"
                )
            )
        )
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.etaDisplay == "Less than 1 minute to Stop 1")
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        await autoTest_refreshDataOnceDoesNothingIfNoData()
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        await autoTest_refreshDataOnceDoesNothingIfNoApolloClient()
    }
    
    @Test func availableNotificationOptionsReturnsAllOptionsWhenNoETA() {
        let viewModel = ShuttleInfoContentView.ViewModel()
        #expect(viewModel.availableNotificationOptions == [2, 5, 10])
    }
    
    @Test func availableNotificationOptionsFiltersBasedOnETA() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        // Test with 8 minutes (480 seconds) ETA - should show 2 and 5 minute options
        mockClient.queryMock = Mock<Query>(
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: 480, // 8 minutes
                            stop: .init(
                                id: "1",
                                name: "Stop 1"
                            )
                        )
                    ],
                    name: "Shuttle 1"
                )
            )
        )
        
        await viewModel.refreshDataOnce(arguments: arguments)
        #expect(viewModel.availableNotificationOptions == [2, 5])
    }
    
    @Test func availableNotificationOptionsShowsOnlyTwoMinutesForShortETA() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        // 3 minutes (180 seconds) ETA should show only 2 minute option
        mockClient.queryMock = Mock<Query>(
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: 180,
                            stop: .init(
                                id: "1",
                                name: "Stop 1"
                            )
                        )
                    ],
                    name: "Shuttle 1"
                )
            )
        )
        
        await viewModel.refreshDataOnce(arguments: arguments)
        #expect(viewModel.availableNotificationOptions == [2])
    }
    
    @Test func availableNotificationOptionsShowsNoOptionsForVeryShortETA() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        // 1 minute (60 seconds) ETA should show no options
        mockClient.queryMock = Mock<Query>(
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: 60,
                            stop: .init(
                                id: "1",
                                name: "Stop 1"
                            )
                        )
                    ],
                    name: "Shuttle 1"
                )
            )
        )
        
        await viewModel.refreshDataOnce(arguments: arguments)
        #expect(viewModel.availableNotificationOptions == [])
    }
    
    @Test func availableNotificationOptionsShowsAllOptionsForLongETA() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        // 15 minutes (900 seconds) ETA - should show all options
        mockClient.queryMock = Mock<Query>(
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: 900,
                            stop: .init(
                                id: "1",
                                name: "Stop 1"
                            )
                        )
                    ],
                    name: "Shuttle 1"
                )
            )
        )
        
        await viewModel.refreshDataOnce(arguments: arguments)
        #expect(viewModel.availableNotificationOptions == [2, 5, 10])
    }
}
