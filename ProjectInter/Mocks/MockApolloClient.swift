//
//  MockApolloClient.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import Foundation
import Apollo
import ApolloAPI

//class MockApolloClient : ApolloClientProtocol {
//    var store: Apollo.ApolloStore
//    
//    init(store: Apollo.ApolloStore) {
//        self.store = store
//    }
//
//    func fetch<Query>(query: Query, cachePolicy: Apollo.CachePolicy = .default, contextIdentifier: UUID? = nil, context: (any Apollo.RequestContext)? = nil, queue: DispatchQueue = .main, resultHandler: Apollo.GraphQLResultHandler<Query.Data>?) -> (any Apollo.Cancellable) where Query : ApolloAPI.GraphQLQuery {
//        <#code#>
//    }
//    
//    func watch<Query>(query: Query, cachePolicy: Apollo.CachePolicy, context: (any Apollo.RequestContext)?, callbackQueue: DispatchQueue, resultHandler: @escaping Apollo.GraphQLResultHandler<Query.Data>) -> Apollo.GraphQLQueryWatcher<Query> where Query : ApolloAPI.GraphQLQuery {
//        <#code#>
//    }
//    
//    func upload<Operation>(operation: Operation, files: [Apollo.GraphQLFile], context: (any Apollo.RequestContext)?, queue: DispatchQueue, resultHandler: Apollo.GraphQLResultHandler<Operation.Data>?) -> (any Apollo.Cancellable) where Operation : ApolloAPI.GraphQLOperation {
//        <#code#>
//    }
//    
//    func subscribe<Subscription>(subscription: Subscription, context: (any Apollo.RequestContext)?, queue: DispatchQueue, resultHandler: @escaping Apollo.GraphQLResultHandler<Subscription.Data>) -> any Apollo.Cancellable where Subscription : ApolloAPI.GraphQLSubscription {
//        <#code#>
//    }
//    
//    func clearCache(callbackQueue: DispatchQueue, completion: ((Result<Void, Error>) -> Void)?) {
//        if let completion {
//          completion(.success(()))
//        }
//    }
//  
////  func fetch<Query>(
////    query: Query,
////    cachePolicy: Apollo.CachePolicy,
////    contextIdentifier: UUID?,
////    queue: DispatchQueue,
////    resultHandler: Apollo.GraphQLResultHandler<Query.Data>?
////  ) -> Apollo.Cancellable where Query : ApolloAPI.GraphQLQuery {
////    defer {
////      if let resultHandler {
////        resultHandler(.success(GraphQLResult(
////          data: Query.Data(data: .init(["key": "fetchResult"], variables: nil)),
////          extensions: nil,
////          errors: nil,
////          source: .server,
////          dependentKeys: nil
////        )))
////      }
////    }
////    
////    return EmptyCancellable()
////  }
////  
////  func watch<Query>(
////    query: Query,
////    cachePolicy: Apollo.CachePolicy,
////    callbackQueue: DispatchQueue,
////    resultHandler: @escaping Apollo.GraphQLResultHandler<Query.Data>
////  ) -> Apollo.GraphQLQueryWatcher<Query> where Query : ApolloAPI.GraphQLQuery {
////    defer {
////      resultHandler(.success(GraphQLResult(
////        data: Query.Data(data: .init(["key": "watchResult"], variables: nil)),
////        extensions: nil,
////        errors: nil,
////        source: .server,
////        dependentKeys: nil
////      )))
////    }
////    
////    return GraphQLQueryWatcher(
////      client: self,
////      query: query,
////      callbackQueue: callbackQueue,
////      resultHandler: resultHandler
////    )
////  }
////  
////  func perform<Mutation>(
////    mutation: Mutation,
////    publishResultToStore: Bool,
////    queue: DispatchQueue,
////    resultHandler: Apollo.GraphQLResultHandler<Mutation.Data>?
////  ) -> Apollo.Cancellable where Mutation : ApolloAPI.GraphQLMutation {
////    defer {
////      if let resultHandler {
////        resultHandler(.success(GraphQLResult(
////          data: Mutation.Data(data: .init(["key": "performResult"], variables: nil)),
////          extensions: nil,
////          errors: nil,
////          source: .server,
////          dependentKeys: nil
////        )))
////      }
////    }
////    
////    return EmptyCancellable()
////  }
////  
////  func upload<Operation>(
////    operation: Operation,
////    files: [Apollo.GraphQLFile],
////    queue: DispatchQueue,
////    resultHandler: Apollo.GraphQLResultHandler<Operation.Data>?
////  ) -> Apollo.Cancellable where Operation : ApolloAPI.GraphQLOperation {
////    defer {
////      if let resultHandler {
////        resultHandler(.success(GraphQLResult(
////          data: Operation.Data(data: .init(["key": "uploadResult"], variables: nil)),
////          extensions: nil,
////          errors: nil,
////          source: .server,
////          dependentKeys: nil
////        )))
////      }
////    }
////    
////    return EmptyCancellable()
////  }
////  
////  func subscribe<Subscription>(
////    subscription: Subscription,
////    queue: DispatchQueue,
////    resultHandler: @escaping Apollo.GraphQLResultHandler<Subscription.Data>
////  ) -> Apollo.Cancellable where Subscription : ApolloAPI.GraphQLSubscription {
////    defer {
////      resultHandler(.success(GraphQLResult(
////        data: Subscription.Data(data: .init(["key": "subscribeResult"], variables: nil)),
////        extensions: nil,
////        errors: nil,
////        source: .server,
////        dependentKeys: nil
////      )))
////    }
////    
////    return EmptyCancellable()
////  }
//}
