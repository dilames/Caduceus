//
//  Reactive+Functions.swift
//  LetsSurf
//
//  Created by Vlad Kuznetsov on 1/31/18.
//  Copyright © 2018 Cleveroad Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProducer where Value == Void {
    /// A producer for a Signal that sends Void value and immediately completes.
    public static var executingEmpty: SignalProducer {
        return SignalProducer { observer, _ in
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
}

extension Signal where Value == String {
    func mapWithoutWhitespaces() -> Signal<String, Error> {
        return map { $0.replacingOccurrences(of: " ", with: "") }
    }
}

extension SignalProducer {
    func mapToVoid() -> SignalProducer<Void, Error> {
        return map { _ in }
    }
    
    public func flatMap<Inner: SignalProducerConvertible>(
        _ transform: @escaping (Value) -> Inner)
        -> SignalProducer<Inner.Value, Error> where Inner.Error == Error {
            return flatMap(.concat, transform)
    }
    
    public func flatMap<Inner: SignalProducerConvertible>(
        _ transform: @escaping () -> Inner)
        -> SignalProducer<Inner.Value, Error> where Inner.Error == Error {
            return flatMap(.concat, { (_) -> Inner in
                return transform()
            })
    }
    
    func skip<Property: PropertyProtocol>(if property: Property) -> SignalProducer<Value, Error> where Property.Value == Bool {
        return withLatest(from: property.producer)
            .filter {!$0.1}
            .map {$0.0}
    }
    
    var optional: SignalProducer<Value?, Error> {
        return map { Optional($0) }
    }
}

extension Signal {
    func mapToVoid() -> Signal<Void, Error> {
        return map { _ in }
    }
    
    public func flatMap<Inner: SignalProducerConvertible>(
        _ transform: @escaping (Value) -> Inner)
        -> Signal<Inner.Value, Error> where Inner.Error == Error {
            return flatMap(.concat, transform)
    }
    
    public func flatMap<Inner: SignalProducerConvertible>(
        _ transform: @escaping () -> Inner)
        -> Signal<Inner.Value, Error> where Inner.Error == Error {
            return flatMap(.concat, { (_) -> Inner in
                return transform()
            })
    }
    
    func skip<Property: PropertyProtocol>(if property: Property) -> Signal<Value, Error> where Property.Value == Bool {
        return withLatest(from: property.producer)
            .filter {!$0.1}
            .map {$0.0}
    }
    
    var optional: Signal<Value?, Error> {
        return map { Optional($0) }
    }
}

extension Property {
    var optional: Property<Value?> {
        return map { Optional($0) }
    }
}

extension MutableProperty {
    var optional: MutableProperty<Value?> {
        let property = map { Optional($0) }
        let mutableProperty = MutableProperty<Value?>(value)
        mutableProperty <~ property
        return mutableProperty
    }
}

extension Property where Value == String {
    func nilIfEmpty() -> Property<String?> {
        return map {$0.isEmpty ? nil : $0}
    }
}

extension MutableProperty where Value == String {
    func nilIfEmpty() -> Property<String?> {
        return map {$0.isEmpty ? nil : $0}
    }
}
