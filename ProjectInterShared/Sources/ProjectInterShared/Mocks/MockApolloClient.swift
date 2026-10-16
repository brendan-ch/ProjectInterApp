//
//  MockApolloClient.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Foundation
import Apollo
import ApolloAPI
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

/// An error struct thrown by ``MockApolloClient`` in the
/// event of a failed request.
struct MockError: Error {

}

private struct EmptyCancellable: Cancellable {
    func cancel() {}
}

public class MockApolloClient {
    // MARK: - Mock data
    public var queryMock: Mock<ProjectInterTestMocks.Query>?
    public var mutationMock: Mock<ProjectInterTestMocks.Mutation>?

    // MARK: - Function calling data
    public var lastMutationPassed: (any GraphQLMutation)?

    public init() {
    }

    /// Deprecated Apollo 1.x-style callback fetch shape, kept for the
    /// callback-consuming code in the app target. The result handler
    /// is invoked asynchronously, since building `Data` from a test
    /// mock is asynchronous in Apollo 2.x.
    public func fetch<Query>(query: Query, resultHandler: GraphQLResultHandler<Query>? = nil) -> (any Cancellable) where Query : GraphQLQuery {
        guard let mock = queryMock else {
            resultHandler?(.failure(MockError()))
            return EmptyCancellable()
        }

        if let resultHandler {
            Task {
                let data = await Query.Data.from(mock)
                resultHandler(.success(GraphQLResponse(
                    data: data,
                    extensions: nil,
                    errors: nil,
                    source: .server,
                    dependentKeys: nil
                )))
            }
        }

        return EmptyCancellable()
    }

    public func perform<Mutation>(mutation: Mutation, resultHandler: GraphQLResultHandler<Mutation>? = nil) -> (any Cancellable) where Mutation : GraphQLMutation {
        lastMutationPassed = mutation

        guard let mock = mutationMock else {
            resultHandler?(.failure(MockError()))
            return EmptyCancellable()
        }

        if let resultHandler {
            Task {
                let data = await Mutation.Data.from(mock)
                resultHandler(.success(GraphQLResponse(
                    data: data,
                    extensions: nil,
                    errors: nil,
                    source: .server,
                    dependentKeys: nil
                )))
            }
        }

        return EmptyCancellable()
    }
}
