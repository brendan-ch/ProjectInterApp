import Foundation
import os

public enum LogConfig {
    // Reads the subsystem from Info.plist key "LogSubsystem" (if present),
    // else uses the bundle identifier, else a safe default.
    public static func subsystem(bundle: Bundle = .main) -> String {
        if let configured = bundle.object(forInfoDictionaryKey: "LogSubsystem") as? String,
           !configured.isEmpty {
            return configured
        }
        return bundle.bundleIdentifier ?? "dev.bchen.i"
    }
}

public final class Loggers: Sendable {
    public static let shared = Loggers()
    
    public let networkingLogger: Logger
    public let systemEventsLogger: Logger
    public let globalStateEventsLogger: Logger
    
    private init(subsystem: String = LogConfig.subsystem()) {
        self.networkingLogger = Logger(subsystem: subsystem, category: "network")
        self.systemEventsLogger = Logger(subsystem: subsystem, category: "systemEvents")
        self.globalStateEventsLogger = Logger(subsystem: subsystem, category: "globalStateEvents")
    }
}
