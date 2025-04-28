//
//  LoggerSingleton.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.28.
//

import Foundation
import os

class LoggerHolderSingleton {
    let networkingLogger = Logger.init(subsystem: "dev.bchen.Inter", category: "network")
    let systemEventsLogger = Logger.init(subsystem: "dev.bchen.Inter", category: "systemEvents")
    let stateEventsLogger = Logger.init(subsystem: "dev.bchen.inter", category: "stateEvents")
    
    static let shared = LoggerHolderSingleton()
    
    private init() {}
}
