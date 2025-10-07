//
//  ApolloClient.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.10.03.
//

import Apollo

extension ApolloClient: @unchecked Sendable {
    public static let shared = ApolloClient(url: .apiBaseUrl)
}
