//
//  LogLevel.swift
//  shared-utils
//
//  Created by Andrew McKnight on 10/24/17.
//  Copyright © 2017 Two Ring Software. All rights reserved.
//

import Foundation

enum LogLevel: Int {

    case unknown = 0
    case verbose
    case debug
    case info
    case warning
    case error

    static func defaultLevel() -> LogLevel { return .info }

}

extension LogLevel: CustomDebugStringConvertible {

    var debugDescription: String {
        get {
            let s = String(asRDNSForApp: Bundle.getAppName(), domain: "log-level", subpaths: [ description ])
            return s
        }
    }

    /// This isn't actually a function in `CustomdebugStringConvertible` but it's provided for consistent API.
    init?(debugDescription: String) {
        if debugDescription == String(reflecting: LogLevel.unknown) {
            self = .unknown
        } else if debugDescription == String(reflecting: LogLevel.verbose) {
            self = .verbose
        } else if debugDescription == String(reflecting: LogLevel.debug) {
            self = .debug
        } else if debugDescription == String(reflecting: LogLevel.info) {
            self = .info
        } else if debugDescription == String(reflecting: LogLevel.warning) {
            self = .warning
        } else if debugDescription == String(reflecting: LogLevel.error) {
            self = .error
        } else {
            return nil
        }
    }

}

extension LogLevel: CustomStringConvertible {

    var description: String {
        get {
            switch self {
            case .unknown: return "unknown"
            case .verbose: return "verbose"
            case .debug: return "debug"
            case .info: return "info"
            case .warning: return "warning"
            case .error: return "error"
            }
        }
    }

    init?(_ description: String) {
        if description == String(describing: LogLevel.unknown) {
            self = .unknown
        } else if description == String(describing: LogLevel.verbose) {
            self = .verbose
        } else if description == String(describing: LogLevel.debug) {
            self = .debug
        } else if description == String(describing: LogLevel.info) {
            self = .info
        } else if description == String(describing: LogLevel.warning) {
            self = .warning
        } else if description == String(describing: LogLevel.error) {
            self = .error
        } else {
            return nil
        }
    }

}
