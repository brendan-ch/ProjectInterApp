//
//  ApolloClient.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.10.03.
//

import Apollo
import ApolloAPI

extension ApolloClient: @unchecked Sendable {
    public static var shared: ApolloClient { ApolloClient(url: .apiBaseUrl) }
}
