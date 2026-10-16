//
//  MockServerClient.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.05.
//

import Foundation
import Apollo
import ApolloAPI
@_spi(Internal) import ApolloAPI
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks
import ProjectInterLogging
import Network

struct Response: Codable {
    var error: String?
    var success: Bool
    var message: String?
}

/// Mock GraphQL requests with a mock server running alongside the app.
/// See the corresponding [mock server code](https://github.com/brendan-ch/project-inter-mock-server).
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
    
    private func constructJsonSerializableDictionary<Query>(query: Query, response: Mock<ProjectInterTestMocks.Query>) async -> [String: Any] where Query : ApolloAPI.GraphQLOperation {
        let requestBody = bodyCreator.requestBody(for: query, sendQueryDocument: true, autoPersistQuery: false)
        var jsonBodyObject = requestBody.compactMapValues { $0._jsonValue } as [String : Any]

        let data = await Query.Data.from(response)
        let result = GraphQLResponse<Query>(
            data: data,
            extensions: nil,
            errors: nil,
            source: .server,
            dependentKeys: nil
        )
        let dict = result.asJSONDictionary()
        jsonBodyObject["response"] = dict

        return jsonBodyObject
    }
    
    func mock<Query>(query: Query, response: Mock<ProjectInterTestMocks.Query>) async where Query : ApolloAPI.GraphQLOperation {
        let jsonDictionary = await constructJsonSerializableDictionary(query: query, response: response)
        
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: jsonDictionary) else {
            Loggers.shared.networkingLogger.error("Failed to construct JSON representation of data: \(jsonDictionary)")
            return
        }

        guard let url = buildMockApiUrl(paths: ["mocks"]) else {
            Loggers.shared.networkingLogger.error("Failed to build mock URL using buildMockApiUrl")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                Loggers.shared.networkingLogger.info("Mocked response \(data) for query \(jsonDictionary)")
                print(decodedResponse)
            }
        } catch {
            Loggers.shared.networkingLogger.error("Failed to call the mock server for query \(jsonDictionary)")
        }
    }
    
    func clear() async {
        guard let url = buildMockApiUrl(paths: ["mocks"]) else {
            print("Failed to build mock URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            Loggers.shared.networkingLogger.info("Cleared all mock data")
        } catch {
            Loggers.shared.networkingLogger.error("Failed to clear mock data")
        }
    }
}
