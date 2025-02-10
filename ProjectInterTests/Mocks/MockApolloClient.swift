//
//  MockApolloClient.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Foundation
@testable import Apollo
@testable import ApolloAPI
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

/// An error struct thrown by ``MockApolloClient`` in the
/// event of a failed request.
struct MockError: Error {
    
}

class MockApolloClient: ApolloClientProtocol {
    // MARK: - Mock data
    var queryMock: Mock<ProjectInterTestMocks.Query>?
    var mutationMock: Mock<ProjectInterTestMocks.Mutation>?
    
    // MARK: - ApolloClientProtocol conformance
    var store: Apollo.ApolloStore
    
    init() {
        store = Apollo.ApolloStore()
    }
    
    func perform<Mutation>(mutation: Mutation, publishResultToStore: Bool, contextIdentifier: UUID?, context: (any Apollo.RequestContext)?, queue: DispatchQueue, resultHandler: Apollo.GraphQLResultHandler<Mutation.Data>?) -> (any Apollo.Cancellable) where Mutation : ApolloAPI.GraphQLMutation {
        return EmptyCancellable()
    }

    func clearCache(callbackQueue: DispatchQueue, completion: ((Result<Void, any Error>) -> Void)?) {
    }
    
    func watch<Query>(query: Query, cachePolicy: Apollo.CachePolicy, context: (any Apollo.RequestContext)?, callbackQueue: DispatchQueue, resultHandler: @escaping Apollo.GraphQLResultHandler<Query.Data>) -> Apollo.GraphQLQueryWatcher<Query> where Query : ApolloAPI.GraphQLQuery {
        return GraphQLQueryWatcher(client: self, query: query, resultHandler: resultHandler)
    }
    
    func upload<Operation>(operation: Operation, files: [Apollo.GraphQLFile], context: (any Apollo.RequestContext)?, queue: DispatchQueue, resultHandler: Apollo.GraphQLResultHandler<Operation.Data>?) -> (any Apollo.Cancellable) where Operation : ApolloAPI.GraphQLOperation {
        return EmptyCancellable()
    }
    
    func subscribe<Subscription>(subscription: Subscription, context: (any Apollo.RequestContext)?, queue: DispatchQueue, resultHandler: @escaping Apollo.GraphQLResultHandler<Subscription.Data>) -> any Apollo.Cancellable where Subscription : ApolloAPI.GraphQLSubscription {
        return EmptyCancellable()
    }
    
    func fetch<Query>(query: Query, cachePolicy: CachePolicy = .default, contextIdentifier: UUID? = nil, context: (any RequestContext)? = nil, queue: DispatchQueue = .main, resultHandler: GraphQLResultHandler<Query.Data>? = nil) -> (any Cancellable) where Query : GraphQLQuery {
        
        guard let mock = queryMock else {
            resultHandler?(.failure(MockError()))
            return EmptyCancellable()
        }
        
        if let resultHandler {
            resultHandler(.success(GraphQLResult(
                data: Query.Data.from(mock),
                extensions: nil,
                errors: nil,
                source: .server,
                dependentKeys: nil
            )))
        }
        
        return EmptyCancellable()
    }
}
