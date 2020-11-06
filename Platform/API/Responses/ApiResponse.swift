//
//  ApiResponse.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import RealmSwift

struct ApiResponse<Value: Decodable>: Decodable {
    
    typealias ValueTransform<T> = (Value) throws -> T
    typealias Transform<T> = () throws -> T
    
    let data: Value
    
    func map<T>(_ transform: ValueTransform<T>) rethrows -> T {
        return try transform(data)
    }
    
    func map<T>(_ transform: Transform<T>) rethrows -> T {
        return try transform()
    }
}
