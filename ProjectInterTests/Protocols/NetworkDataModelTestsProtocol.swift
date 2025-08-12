//
//  NetworkDataModelProtocolTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.14.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

protocol NetworkDataModelTestsProtocol {
    associatedtype DefaultMock
    associatedtype SecondaryMock
    associatedtype NetworkArguments
    associatedtype ViewModel: NetworkDataModelProtocol where ViewModel.NetworkArguments == NetworkArguments
    
    func assertViewModelDataForDefaultMock(viewModel: ViewModel)
    func assertViewModelDataForSecondaryMock(viewModel: ViewModel)
    func assertViewModelDataForEmptyMock(viewModel: ViewModel)
    
    func generateClientAndViewModelWithArguments() -> (MockApolloClient, ViewModel, NetworkArguments)
    
    var defaultMock: DefaultMock { get }
    var secondaryMock: SecondaryMock { get }
    
    var networkArguments: NetworkArguments { get }

    func startRefreshingDataRefreshesDataOnFirstCall() async
    func startRefreshingDataRefreshesDataMultipleTimes() async
    func stopRefreshingDataStopsDataUpdatesAfterCompletion() async
    func refreshDataOnceUpdatesData() async
    func refreshDataOnceDoesNothingIfNoData() async
    func refreshDataOnceDoesNothingIfNoApolloClient() async
}

extension NetworkDataModelTestsProtocol {
    func generateClientAndViewModelWithArguments() -> (MockApolloClient, ViewModel, NetworkArguments) {
        let mockClient = MockApolloClient()
        let networkModel = ApolloNetworkModel(client: mockClient)
        
        let viewModel = ViewModel(apolloNetworkModel: networkModel)
        let arguments = networkArguments
        return (mockClient, viewModel, arguments)
    }
    
    // This set of functions completely run the networking portion
    // of the tests using the associated types.
    // In the class implementing the protocol, call these in
    // test methods using the @Test decorators, as the decorator
    // cannot be applied here.
    
    func autoTest_startRefreshingDataRefreshesDataOnFirstCall() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock as? Mock<Query>
        
        let networkModel = ApolloNetworkModel(client: mockClient)

        let viewModel = ViewModel(apolloNetworkModel: networkModel)
        viewModel.startRefreshingData(arguments: networkArguments, sleepDuration: .milliseconds(1000))
        try? await Task.sleep(for: .milliseconds(500))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    func autoTest_startRefreshingDataRefreshesDataMultipleTimes() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock as? Mock<Query>
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        
        let viewModel = ViewModel(apolloNetworkModel: networkModel)
        let arguments = networkArguments
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(100))
        
        try? await Task.sleep(for: .milliseconds(1000))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
        
        mockClient.queryMock = secondaryMock as? Mock<Query>
        
        try? await Task.sleep(for: .milliseconds(600))
        
        assertViewModelDataForSecondaryMock(viewModel: viewModel)
    }
    
    func autoTest_stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock as? Mock<Query>
        
        let networkModel = ApolloNetworkModel(client: mockClient)

        let viewModel = ViewModel(apolloNetworkModel: networkModel)
        viewModel.startRefreshingData(arguments: networkArguments, sleepDuration: .milliseconds(100))
        
        try? await Task.sleep(for: .milliseconds(1000))
        
        viewModel.stopRefreshingData()
        mockClient.queryMock = secondaryMock as? Mock<Query>
        
        try? await Task.sleep(for: .milliseconds(1000))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    func autoTest_refreshDataOnceUpdatesData() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock as? Mock<Query>
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        
        let viewModel = ViewModel(apolloNetworkModel: networkModel)
        let arguments = networkArguments
        await viewModel.refreshDataOnce(arguments: arguments)
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    func autoTest_refreshDataOnceDoesNothingIfNoData() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = nil
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        
        let viewModel = ViewModel(apolloNetworkModel: networkModel)
        let arguments = networkArguments
        await viewModel.refreshDataOnce(arguments: arguments)
        
        assertViewModelDataForEmptyMock(viewModel: viewModel)
    }
    
    func autoTest_refreshDataOnceDoesNothingIfNoApolloClient() async {
        let viewModel = ViewModel(apolloNetworkModel: nil)
        let arguments = networkArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        assertViewModelDataForEmptyMock(viewModel: viewModel)
    }
}
