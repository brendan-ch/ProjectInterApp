//
//  URLSerializable.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.10.07.
//

import Foundation

/// Defines a struct that can be fully represented by a URL.
protocol URLRepresentable: DictionaryConstructable {
    static var expectedUrlPath: String { get }
    func toUrl() -> URL?
}

fileprivate struct AnyEncodable<T: Encodable>: Encodable {
    let base: T
    init(_ base: T) {
        self.base = base
    }
    func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

extension URLRepresentable {
    func toUrl() -> URL? {
        let base = "interchange://x-callback-url\(Self.expectedUrlPath)"

        var queryItems: [URLQueryItem] = []
        do {
            let encoder = JSONEncoder()
            // Keep keys as-is; adjust date/strategy here if needed in the future
            let data = try encoder.encode(AnyEncodable(self))
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let dict = json as? [String: Any] {
                queryItems = makeQueryItems(from: dict)
            }
        } catch {
            queryItems = []
        }

        if var components = URLComponents(string: base) {
            if !queryItems.isEmpty {
                components.queryItems = queryItems
            }
            if let url = components.url {
                return url
            }
        }

        return nil
    }

    private func makeQueryItems(from dict: [String: Any]) -> [URLQueryItem] {
        return dict.map { key, value in
            URLQueryItem(name: key, value: stringify(value))
        }
    }

    private func stringify(_ value: Any) -> String {
        switch value {
        case let v as String:
            return v
        case let v as CustomStringConvertible:
            return v.description
        default:
            // As a last resort, JSON-encode the value to preserve structure
            if JSONSerialization.isValidJSONObject(value),
               let data = try? JSONSerialization.data(withJSONObject: value, options: []),
               let s = String(data: data, encoding: .utf8) {
                return s
            }
            return "\(value)"
        }
    }
}
