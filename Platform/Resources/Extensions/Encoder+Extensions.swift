//
//  Encoder+Extensions.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import RealmSwift

extension KeyedEncodingContainer {
    // MARK: - Date
    mutating func encodeDate(_ date: Date, with dateFormatter: DateFormatter, forKey key: K) throws {
     	let dateString = dateFormatter.string(from: date)
        try encode(dateString, forKey: key)
    }
    
    mutating func encodeDateIfPresent(_ date: Date?, with dateFormatter: DateFormatter, forKey key: K) throws {
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            try encode(dateString, forKey: key)
        }
    }
    
    // MARK: - List
    mutating func encode<RMObject>(_ list: List<RMObject>, forKey key: K) throws where RMObject: Encodable {
        let objects = Array(list)
        try encode(objects, forKey: key)
    }
    
    mutating func encodeIfPresent<RMObject>(_ list: List<RMObject>?, forKey key: K) throws where RMObject: Encodable {
        if let list = list {
            let objects = Array(list)
            try encode(objects, forKey: key)
        }
    }
}
