//
//  SchemaVersionModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.24.
//

@testable import ProjectInter
import Testing
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

class SchemaVersionModelTests: NetworkDataModelTestsProtocol {
    let defaultMock = Mock<Query>(
        schemaCurrentVersion: 5,
        schemaMinVersion: 2
    )
    
    let secondaryMock = Mock<Query>(
        schemaCurrentVersion: 10,
        schemaMinVersion: 8
    )
    
    let networkArguments = SchemaVersionModelNetworkArguments()
    
    func assertViewModelDataForDefaultMock(viewModel: SchemaVersionModel) {
        #expect(viewModel.serverMinSchemaVersion == 2)
        #expect(viewModel.serverCurrentSchemaVersion == 5)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: SchemaVersionModel) {
        #expect(viewModel.serverMinSchemaVersion == 10)
        #expect(viewModel.serverCurrentSchemaVersion == 8)
    }
    
    func assertViewModelDataForEmptyMock(viewModel: SchemaVersionModel) {
        #expect(viewModel.serverMinSchemaVersion == nil)
        #expect(viewModel.serverCurrentSchemaVersion == nil)
    }
    
    func startRefreshingDataRefreshesDataOnFirstCall() async {
        await autoTest_startRefreshingDataRefreshesDataOnFirstCall()
    }
    
    func startRefreshingDataRefreshesDataMultipleTimes() async {
        await autoTest_startRefreshingDataRefreshesDataMultipleTimes()
    }
    
    func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        await autoTest_stopRefreshingDataStopsDataUpdatesAfterCompletion()
    }
    
    func refreshDataOnceUpdatesData() async {
        await autoTest_refreshDataOnceUpdatesData()
    }
    
    func refreshDataOnceDoesNothingIfNoData() async {
        await autoTest_refreshDataOnceDoesNothingIfNoData()
    }
    
    func refreshDataOnceDoesNothingIfNoApolloClient() async {
        await autoTest_refreshDataOnceDoesNothingIfNoApolloClient()
    }
    
    
}
