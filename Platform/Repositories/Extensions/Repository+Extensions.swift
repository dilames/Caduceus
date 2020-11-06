//
//  Repository+Extensions.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/18/18.
//

import Foundation
import Result

extension Repository {
    func query(by predicate: NSPredicate? = nil,
               sortedBy sorting: Sorting? = nil,
               completion: Completion<[Entity]>) {
		query(by: predicate, sortedBy: sorting, completion: completion)
    }
    
    func queryFirst(by predicate: NSPredicate? = nil,
                    sortedBy sorting: Sorting? = nil,
                    completion: Completion<Entity?>) {
        query(by: predicate, sortedBy: sorting) { result in
            switch result {
            case .success(let value):
                completion(.success(value.first))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
