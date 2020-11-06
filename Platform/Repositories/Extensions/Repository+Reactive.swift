//
//  Repository+Reactive.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/18/18.
//

import Foundation
import ReactiveSwift
import Result

extension Reactive where Base: Repository {
    typealias BaseSorting = (Base.Entity, Base.Entity) throws -> Bool
    
    func save(_ entity: Base.Entity) -> SignalProducer<Void, AnyError> {
        return SignalProducer { observer, _ in
            self.base.save(entity) { result in
                switch result {
                case .success:
                    observer.send(value: ())
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            }
        }
    }
    
    func delete(_ entity: Base.Entity) -> SignalProducer<Void, AnyError> {
        return SignalProducer { observer, _ in
            self.base.delete(entity) { result in
                switch result {
                case .success:
                    observer.send(value: ())
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            }
        }
    }
    
    func query(by predicate: NSPredicate? = nil,
               sortedBy sorting: BaseSorting? = nil)
        -> SignalProducer<[Base.Entity], AnyError>
    {
        return SignalProducer { observer, _ in
            self.base.query(by: predicate, sortedBy: sorting, completion: { result in
                switch result {
                case .success(let objects):
                    observer.send(value: objects)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            })
        }
    }
    
    func queryFirst(by predicate: NSPredicate? = nil,
                    sortedBy sorting: BaseSorting? = nil)
        -> SignalProducer<Base.Entity?, AnyError>
    {
        return SignalProducer { observer, _ in
            self.base.queryFirst(by: predicate, sortedBy: sorting, completion: { result in
                switch result {
                case .success(let value):
                    observer.send(value: value)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            })
        }
    }
}
