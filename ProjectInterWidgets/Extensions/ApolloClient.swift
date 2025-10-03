//
//  ApolloClient.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import Apollo

extension ApolloClient {
    static let shared = ApolloClient(url: .apiBaseUrl)
}
