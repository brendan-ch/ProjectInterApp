//
//  String.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2026.10.16.
//

import Foundation

extension String {
    func toAppleMapsUrl() -> URL? {
        var percentageEncodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let percentageEncodedString = percentageEncodedString else { return nil }
        return URL(string: "https://maps.apple.com/?address=\(percentageEncodedString)")
    }
    
    func toGoogleMapsUrl() -> URL? {
        var percentageEncodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let percentageEncodedString = percentageEncodedString else { return nil }
        return URL(string: "https://www.google.com/maps?q=\(percentageEncodedString)")

    }
}
