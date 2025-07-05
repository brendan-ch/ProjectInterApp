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
    var success: Bool
    var message: String?
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
        
        let pathString = "/" + paths.joined(separator: "/")
        components.path = pathString
        
        return components.url
    }
    
    func mock<Query>(query: Query, variables: [String: Any] = [:], response: Mock<ProjectInterTestMocks.Query>) async where Query : ApolloAPI.GraphQLOperation {
        
        let requestBody = bodyCreator.requestBody(for: query, sendQueryDocument: true, autoPersistQuery: false)
        var jsonBodyObject = requestBody.compactMapValues { $0._jsonValue } as [String : Any]
        
        let result = GraphQLResult(
            data: Query.Data.from(response),
            extensions: nil,
            errors: nil,
            source: .server,
            dependentKeys: nil
        )
        let dict = result.asJSONDictionary()
        jsonBodyObject["response"] = dict
        
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: jsonBodyObject) else {
            print("Failed to construct JSON representation of data")
            return
        }

        guard let url = buildMockApiUrl(paths: ["mocks"]) else {
            print("Failed to build mock URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                print(decodedResponse)
            }
        } catch {
            print("Failed to call the mock server")
        }
    }
}
