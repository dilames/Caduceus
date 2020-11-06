//
//  AbstractRepository.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/16/18.
//

import Foundation
import protocol ReactiveSwift.ReactiveExtensionsProvider
import Result

protocol Repository: ReactiveExtensionsProvider {
    associatedtype Entity
    
    typealias Output<T> = Result<T, AnyError>
    typealias Completion<T> = (Output<T>) -> Void
    typealias Sorting = (Entity, Entity) throws -> Bool
    
    func save(_ entity: Entity, _ completion: Completion<Void>)
    
    func delete(_ entity: Entity, _ completion: Completion<Void>)
    
    func query(by predicate: NSPredicate?,
               sortedBy sorting: Sorting?,
               completion: Completion<[Entity]>)
}
