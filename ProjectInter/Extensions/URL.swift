//
//  URL.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.06.15.
//

import Foundation
import ProjectInterShared

extension URL {
    static var defaultApiBaseUrl: URL { URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)! }
    static var feedbackUrl: URL { URL(string: Bundle.main.infoDictionary!["FEEDBACK_URL"] as! String)! }
    static var changelogUrl: URL { URL(string: Bundle.main.infoDictionary!["CHANGELOG_URL"] as! String)! }
    static var acknowledgementsUrl: URL { URL(string: Bundle.main.infoDictionary!["ACKNOWLEDGEMENTS_URL"] as! String)! }
}
