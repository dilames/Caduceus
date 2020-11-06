//
//  Decoder+Extensions.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/16/18.
//

import Foundation
import RealmSwift

public extension KeyedDecodingContainer where K : CodingKey {
    // MARK: - Date
    public func decodeDate(_ dateFormatter: DateFormatter, forKey key: K) throws -> Date {
        let dateString = try decode(String.self, forKey: key)
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.typeMismatch(
                Date.self,
                DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Invalid date")
            )
        }
        return date
    }
    
    public func decodeDateIfPresent(_ dateFormatter: DateFormatter, forKey key: K) throws -> Date? {
        let dateString = try decodeIfPresent(String.self, forKey: key)
        if let dateString = dateString {
            if let date = dateFormatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.typeMismatch(
                    Date.self,
                    DecodingError.Context(
                        codingPath: codingPath,
                        debugDescription: "Invalid date")
                )
            }
        } else {
            return nil
        }
    }
    
    // MARK: - List
    public func decode<RMObject>(_ list: List<RMObject>.Type, forKey key: K)
        throws -> List<RMObject>
        where RMObject: Object & Decodable
    {
        let array = try decode(Array<RMObject>.self, forKey: key)
        let list: List<RMObject> = .init()
        list.append(objectsIn: array)
        return list
    }
    
    public func decodeIfPresent<RMObject>(_ list: List<RMObject>.Type, forKey key: K)
        throws -> List<RMObject>?
        where RMObject: Object & Decodable
    {
        guard let array = try decodeIfPresent(Array<RMObject>.self, forKey: key) else {
            return nil
        }
        let list: List<RMObject> = .init()
        list.append(objectsIn: array)
        return list
    }
}
