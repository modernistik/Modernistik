//
//  DateFormatterCache.swift
//  Modernistik
//
//  Created by Anthony Persaud on 10/25/19.
//

import Foundation
import UIKit

public extension Date {
    /// Formats the date object to the corresponding date format in thread-safe way while reusing existing DateFormatters
    /// that have been used previously.
    /// - Parameters:
    ///   - format: The format string to use.
    ///   - timeZone: The time zone in which to format the date-time
    /// - Returns: A string representation of the date in the requested format.
    func formatted(_ format: String, timeZone: TimeZone = .current) -> String {
        DateFormatterCache.with(format: format, timeZone: timeZone).string(from: self)
    }
}

public
enum DateFormatterCache {
    // synchronization queue since dictionaries are not thread-safe.
    // Single queue access to the catalog
    private static var queue = DispatchQueue(label: "DateFormatterCache.queue", attributes: .concurrent)
    private static var formatterCatalog = [String: DateFormatter]()
    private static func cacheKey(format: String, timeZone: TimeZone) -> String {
        "\(format):\(timeZone.identifier)"
    }

    public
    static func with(format: String, timeZone: TimeZone = .current) -> DateFormatter {
        let key = cacheKey(format: format, timeZone: timeZone)
        // Handle thread-safety of dictionary

        var cachedFormatter: DateFormatter?
        queue.sync {
            cachedFormatter = formatterCatalog[key]
        }
        // if we have one, return it.
        if let cachedFormatter = cachedFormatter { return cachedFormatter }
        let formatter = createFormatter(format: format, timeZone: timeZone)
        add(formatter)
        return formatter
    }

    public static func createFormatter(format: String, timeZone: TimeZone) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter
    }

    public
    static func add(_ formatter: DateFormatter) {
        guard let dateFormat = formatter.dateFormat, let timeZone = formatter.timeZone else {
            assertionFailure("Argument formatter lacks a dateFormat value.")
            return
        }
        // queue.async(flags: .barrier) <-- will move to this in the future if it's a concurrency issue
        queue.async(flags: .barrier) {
            let key = cacheKey(format: dateFormat, timeZone: timeZone)
            // We might accidentally create double formatters in race-conditions,
            // but ultimately we will reach eventual consistency with the latest formatter created.
            formatterCatalog[key] = formatter
        }
    }

    public
    static func clear() {
        // queue.async(flags: .barrier) <-- will move to this in the future if it's a concurrency issue
        // guarantee serial queue to improve thread-safety.
        queue.async(flags: .barrier) {
            formatterCatalog.removeAll(keepingCapacity: true)
        }
    }
}
