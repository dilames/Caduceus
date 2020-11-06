//
//  Date+Extensions.swift
//  Extensions
//
//  Created by Andrew Chersky  on 3/8/18.
//

import Foundation

public extension Date {
    public var readableDescription: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: self)
    }
}
