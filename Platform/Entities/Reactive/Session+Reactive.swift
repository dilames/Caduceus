//
//  Session+Reactive.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/20/18.
//

import Foundation
import ReactiveSwift
import Result

extension UserSession: ReactiveExtensionsProvider {}

extension Reactive where Base: UserSession {
    func save() -> SignalProducer<Void, AnyError> {
        return SignalProducer { observer, _ in
            do {
            	try self.base.save()
                observer.send(value: ())
                observer.sendCompleted()
            } catch {
                observer.send(error: .init(error))
            }
        }
    }
    
    func invalidate() -> SignalProducer<Void, AnyError> {
        return SignalProducer { observer, _ in
            do {
                try self.base.invalidate()
                observer.send(value: ())
                observer.sendCompleted()
            } catch {
                observer.send(error: .init(error))
            }
        }
    }
}
