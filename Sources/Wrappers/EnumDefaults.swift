//
//  File.swift
//  
//
//  Created by Anthony Persaud on 12/16/21.
//

import Foundation

@propertyWrapper
/// A property wrapper that stores a Enum type in UserDefaults where the underlying raw value is a String.
public struct EnumDefaults<EnumType> where EnumType: RawRepresentable, EnumType.RawValue == String {
    let key: String
    let defaultValue: EnumType
    var storage = UserDefaults.standard

    public init(_ key: String, fallback: EnumType) {
        self.key = key
        defaultValue = fallback
    }

    public var wrappedValue: EnumType {
        get {
            if let value = storage.string(forKey: key), let e = EnumType(rawValue: value) {
                return e
            }
            return defaultValue
        }
        set {
            storage.set(newValue.rawValue, forKey: key)
        }
    }
}

@propertyWrapper
/// A property wrapper that stores a Enum type in UserDefaults where the underlying raw value is an integer.
public struct EnumIntDefaults<EnumType> where EnumType: RawRepresentable, EnumType.RawValue == Int {
    let key: String
    let defaultValue: EnumType
    var storage = UserDefaults.standard

    public init(_ key: String, fallback: EnumType) {
        self.key = key
        defaultValue = fallback
    }
    
    public var wrappedValue: EnumType {
        get {
            let value = storage.integer(forKey: key)
            return EnumType(rawValue: value) ?? defaultValue
        }
        set {
            storage.set(newValue.rawValue, forKey: key)
        }
    }
}
