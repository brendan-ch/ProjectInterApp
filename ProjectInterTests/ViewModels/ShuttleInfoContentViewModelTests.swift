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
    
    func generateClientAndViewModelWithArguments() -> (MockApolloClient, ShuttleInfoContentViewModel, ShuttleInfoNetworkArguments) {
        let mockClient = MockApolloClient()
        
        let viewModel = ShuttleInfoContentViewModel(apolloClient: mockClient)
        let arguments = networkArguments
        return (mockClient, viewModel, arguments)
    }
    
    func assertViewModelDataForDefaultMock(viewModel: ShuttleInfoContentViewModel) {
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
    
    func assertViewModelDataForSecondaryMock(viewModel: ShuttleInfoContentViewModel) {
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
    
    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        await testStartRefreshingDataRefreshesDataOnFirstCall()
    }


    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.queryMock = defaultMock
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(100))
        try? await Task.sleep(for: .milliseconds(500))
        
        mockClient.queryMock = secondaryMock
        try? await Task.sleep(for: .milliseconds(600))
        
        assertViewModelDataForSecondaryMock(viewModel: viewModel)
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.queryMock = defaultMock
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(100))
        try? await Task.sleep(for: .milliseconds(600))
        
        viewModel.stopRefreshingData()
        
        mockClient.queryMock = secondaryMock
        try? await Task.sleep(for: .milliseconds(700))

        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.queryMock = defaultMock
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
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
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.queryMock = nil

        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.name == "")
        #expect(viewModel.etaDisplay == "ETA currently not available")
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        let (_, viewModel, arguments) = generateClientAndViewModelWithArguments()
        viewModel.apolloClient = nil
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.name == "")
        #expect(viewModel.etaDisplay == "ETA currently not available")
    }
}
