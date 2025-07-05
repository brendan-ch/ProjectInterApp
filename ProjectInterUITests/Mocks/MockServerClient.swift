//
//  MockServerClient.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.05.
//

import Foundation
import Apollo
import ApolloAPI
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks
import Network

struct Response: Codable {
    var error: String?
    var success: Bool?
    var message: String?
    var hash: String?
    var query: String?
}

// Mock server code: https://github.com/brendan-ch/project-inter-mock-server
class MockServerClient {
    private let bodyCreator = ApolloRequestBodyCreator()
    private let baseUrl: URL
    
    init(url: URL) {
        self.baseUrl = url
    }
    
    private func buildMockApiUrl(paths: [String]) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        
        // Add paths
        let pathString = "/" + paths.joined(separator: "/")
        components.path = pathString
        
        return components.url
    }
    
    func mock(query: any GraphQLQuery, variables: [String: Any] = [:], response: Mock<Query>) async {
        let requestBody = bodyCreator.requestBody(for: query, sendQueryDocument: true, autoPersistQuery: false)
        let jsonObject = requestBody.compactMapValues { $0._jsonValue }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject) else {
            print("Failed to construct JSON representation of data")
            return
        }
        
        // TODO: Add the response object
        // https://github.com/apollographql/apollo-ios/issues/3196
        
        guard let url = buildMockApiUrl(paths: ["mocks"]) else {
            print("Failed to build mock URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                print(decodedResponse)
            }
        } catch {
            print("Failed to call the mock server")
        }
    }
}
