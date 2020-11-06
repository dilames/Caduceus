//
//  RealmRepository.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/16/18.
//

import Foundation
import RealmSwift
import ReactiveSwift
import Result

final class RealmRepository<RMObject: Object>: Repository {

    func save(_ entity: RMObject, _ completion: Completion<Void>) {
        let realm = makeRealm()
        do {
            try realm.write {
                let shouldUpdate = RMObject.primaryKey() != nil
//                realm.add(entity, update: shouldUpdate)
                completion(.success(()))
            }
        } catch {
            completion(.failure(.init(error)))
        }
    }
    
    func delete(_ entity: RMObject, _ completion: Completion<Void>) {
        let realm = makeRealm()
        do {
            try realm.write {
                realm.delete(entity)
                completion(.success(()))
            }
        } catch {
            completion(.failure(.init(error)))
        }
    }
    
    func query(by predicate: NSPredicate? = nil,
               sortedBy sorting: ((RMObject, RMObject) throws -> Bool)? = nil,
               completion: Completion<[RMObject]>) {
        let realm = makeRealm()
        do {
            var results = realm.objects(RMObject.self)
            if let predicate = predicate {
                results = results.filter(predicate)
            }
            if let sorting = sorting {
                let resultsArray = try results.sorted(by: sorting)
                completion(.success(resultsArray))
            } else {
                completion(.success(Array(results)))
            }
        } catch {
            completion(.failure(.init(error)))
        }
    }

    private func makeRealm() -> Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - ObservableRepository
extension RealmRepository: ObservableRepository {
    @discardableResult
    func observeChanges(filteredBy predicate: NSPredicate?,
                        changes: @escaping ChangeBlock) -> Cancellable? {
        let realm = makeRealm()
        var entities = realm.objects(Entity.self)
        if let predicate = predicate {
            entities = entities.filter(predicate)
        }
        let nofiticationToken = entities.observe { (collectionChange) in
            switch collectionChange {
            case .initial:
                changes(.initial)
            case .error(let error):
                changes(.error(error))
            case .update(_, let deletions, let insertions, let modifications):
                changes(.update(insertions: insertions, deletions: deletions, modifications: modifications))
            }
        }
        let cancellable = BlockCancellable {
            nofiticationToken.invalidate()
        }
        return cancellable
    }

}
