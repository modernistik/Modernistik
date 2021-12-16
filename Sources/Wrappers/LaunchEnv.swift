//
//  File.swift
//  
//
//  Created by Anthony Persaud on 12/16/21.
//

import Foundation


@propertyWrapper
public struct LaunchEnv {
    let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: String? {
        get {
            #if DEBUG
                return ProcessInfo.processInfo.environment[key]?.trimmed.presence
            #else
                return nil
            #endif
        }
        set {
            fatalError("Launch environment variables are read-only!")
        } // noop
    }
}

@propertyWrapper
public struct LaunchEnvOption {
    let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Bool {
        get {
            ProcessInfo.processInfo.environment[key]?.trimmed.presence != nil
        }
        set {
            fatalError("Launch environment variables are read-only!")
        } // noop
    }
}
