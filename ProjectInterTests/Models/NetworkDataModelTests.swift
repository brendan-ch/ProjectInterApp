//
//  NetworkDataModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.15.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks
import ProjectInterOperations

/// Spy subclass exposing the data that ``injectUpdate`` routed through
/// ``processRefreshDataResult``.
class SpyNetworkDataModel: NetworkDataModel<GetSchemaVersionQuery> {
    var receivedResults: [Result<GetSchemaVersionQuery.Data, any Error>] = []
    let updateError: any Error = TestUpdateError()

    @MainActor
    override func processRefreshDataResult(_ result: Result<GetSchemaVersionQuery.Data, any Error>) {
        receivedResults.append(result)
    }
}

struct TestUpdateError: Error {}

class NetworkDataModelTests {
    static let defaultSchemaVersionMock = Mock<ProjectInterTestMocks.Query>(
        schemaCurrentVersion: 5,
        schemaMinVersion: 2
    )

    @Test func injectUpdateRoutesSuccessToProcessRefreshDataResult() async {
        let model = SpyNetworkDataModel()
        let data = await GetSchemaVersionQuery.Data.from(Self.defaultSchemaVersionMock)

        await model.injectUpdate(.success(data))

        #expect(model.receivedResults.count == 1)
        let first = try? model.receivedResults[0].get()
        #expect(first?.schemaCurrentVersion == Self.defaultSchemaVersionMock.schemaCurrentVersion)
        #expect(first?.schemaMinVersion == Self.defaultSchemaVersionMock.schemaMinVersion)
    }

    @Test func injectUpdateRoutesFailureToProcessRefreshDataResult() async {
        let model = SpyNetworkDataModel()

        await model.injectUpdate(.failure(model.updateError))

        #expect(model.receivedResults.count == 1)
        let first = try? model.receivedResults[0].get()
        #expect(first == nil)
    }

    @Test func injectUpdateIsIdempotent() async {
        let model = SpyNetworkDataModel()
        let data = await GetSchemaVersionQuery.Data.from(Self.defaultSchemaVersionMock)
        let result: Result<GetSchemaVersionQuery.Data, any Error> = .success(data)

        await model.injectUpdate(result)
        await model.injectUpdate(result)

        #expect(model.receivedResults.count == 2)
    }
}
