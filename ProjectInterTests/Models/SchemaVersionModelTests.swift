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
import ProjectInterShared
import ProjectInterTestMocks

class SchemaVersionModelTests {
    let defaultMock = Mock<ProjectInterTestMocks.Query>(
        schemaCurrentVersion: 5,
        schemaMinVersion: 2
    )

    @Test("injectUpdate populates schema versions") func injectUpdatePopulatesSchemaVersions() async {
        let viewModel = SchemaVersionModel(appSchemaVersion: 3)
        let data = await GetSchemaVersionQuery.Data.from(defaultMock)

        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.serverMinSchemaVersion == 2)
        #expect(viewModel.serverCurrentSchemaVersion == 5)
    }

    @Test("injectUpdate with failure leaves schema versions untouched") func injectUpdateFailureLeavesVersionsNil() async {
        let viewModel = SchemaVersionModel(appSchemaVersion: 3)

        await viewModel.injectUpdate(.failure(TestUpdateError()))

        #expect(viewModel.serverMinSchemaVersion == nil)
        #expect(viewModel.serverCurrentSchemaVersion == nil)
    }

    @Test func isCompatiblePropertyIsTrueIfAppSchemaWithinRange() async {
        let viewModel = SchemaVersionModel(appSchemaVersion: 3)
        let data = await GetSchemaVersionQuery.Data.from(defaultMock)
        await viewModel.injectUpdate(.success(data))

        for version in [2, 3, 4, 5] {
            viewModel.appSchemaVersion = version

            #expect(viewModel.isCompatible)
        }
    }

    @Test func isCompatiblePropertyIsFalseIfAppSchemaNotWithinRange() async {
        let viewModel = SchemaVersionModel(appSchemaVersion: 3)
        let data = await GetSchemaVersionQuery.Data.from(defaultMock)
        await viewModel.injectUpdate(.success(data))

        for version in [1, 6, 7, 8] {
            viewModel.appSchemaVersion = version

            #expect(!viewModel.isCompatible)
        }
    }
}
