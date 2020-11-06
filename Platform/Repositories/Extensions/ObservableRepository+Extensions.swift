//
//  ObservableRepository+Extensions.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/25/18.
//

import Foundation

extension ObservableRepository {
    @discardableResult func observeChanges(filteredBy predicate: NSPredicate? = nil,
                                           changes: @escaping ChangeBlock) -> Cancellable? {
        return observeChanges(filteredBy: predicate, changes: changes)
    }
}
