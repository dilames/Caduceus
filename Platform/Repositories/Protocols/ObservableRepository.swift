//
//  ObservableRepository.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/25/18.
//

import Foundation
import ReactiveSwift

enum ObservableRepositoryChange {
    case initial
    case update(insertions: [Int], deletions: [Int], modifications: [Int])
    case error(Error)
}

protocol ObservableRepository: ReactiveExtensionsProvider {
    typealias ChangeBlock = (ObservableRepositoryChange) -> Void
    
    @discardableResult func observeChanges(filteredBy predicate: NSPredicate?,
                                           changes: @escaping ChangeBlock) -> Cancellable?
}
