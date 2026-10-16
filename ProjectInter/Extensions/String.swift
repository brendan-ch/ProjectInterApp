//
//  String.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2026.10.16.
//

import Foundation

extension String {
    func toAppleMapsUrl() -> URL? {
        var components = URLComponents(string: "https://maps.apple.com")
        components?.path = "/place"
        components?.queryItems = [URLQueryItem(name: "address", value: self)]
        return components?.url
    }
    
    func toGoogleMapsUrl() -> URL? {
        var components = URLComponents(string: "https://www.google.com")
        components?.path = "/maps/search/"
        components?.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "query", value: self),
        ]
        return components?.url
    }
}
