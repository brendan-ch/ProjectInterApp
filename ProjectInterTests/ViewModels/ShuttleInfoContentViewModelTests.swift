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

class ShuttleInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let defaultArguments = ShuttleInfoNetworkArguments(systemId: "1", stopId: "1", shuttleId: "1")
    let defaultMock = Mock<Query>(
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
    
    let secondaryMock = Mock<Query>(
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

    func generateClientAndViewModelWithArguments() -> (MockApolloClient, ShuttleInfoContentViewModel, ShuttleInfoNetworkArguments) {
        let mockClient = MockApolloClient()
        
        let viewModel = ShuttleInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        return (mockClient, viewModel, arguments)
    }
    

    func assertViewModelDataForDefaultMock(viewModel: ShuttleInfoContentViewModel) {
        #expect(viewModel.name == "Shuttle 1")
        #expect(viewModel.etaDisplay == "2 min")
        
        // Check sorting of items
        #expect(viewModel.etaListItems.count == 2)
        #expect(viewModel.etaListItems[0].secondsRemaining == 20)
        #expect(viewModel.etaListItems[1].secondsRemaining == 125)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ShuttleInfoContentViewModel) {
        #expect(viewModel.name == "Shuttle 2")
        #expect(viewModel.etaDisplay == "5 min")
        
        
        // Check sorting of items
        #expect(viewModel.etaListItems.count == 2)
        #expect(viewModel.etaListItems[0].secondsRemaining == 205)
        #expect(viewModel.etaListItems[1].secondsRemaining == 306)
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
        try? await Task.sleep(for: .milliseconds(600))
        
        mockClient.mock = secondaryMock
        try? await Task.sleep(for: .milliseconds(500))
        
        assertViewModelDataForSecondaryMock(viewModel: viewModel)
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = defaultMock
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(500))
        try? await Task.sleep(for: .milliseconds(600))
        
        viewModel.stopRefreshingData()
        
        mockClient.mock = secondaryMock
        try? await Task.sleep(for: .milliseconds(500))

        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = defaultMock
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceUpdatesEtaCorrectlyIfUnderOneMin() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        
        mockClient.mock = Mock<Query>(
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
        
        #expect(viewModel.etaDisplay == "Less than 1 minute")
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.mock = nil

        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.name == "")
        #expect(viewModel.etaDisplay == "")
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        let (_, viewModel, arguments) = generateClientAndViewModelWithArguments()
        viewModel.apolloClient = nil
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.name == "")
        #expect(viewModel.etaDisplay == "")
    }
}
