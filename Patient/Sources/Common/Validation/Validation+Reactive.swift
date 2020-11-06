//
//  Validation+Reactive.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Foundation
import Validator
import ReactiveSwift
import Result

extension PropertyProtocol where Value: Validatable {
    func validate<Rule: ValidationRule>(rule: Rule) -> Property<ValidationResult> where Rule.InputType == Value {
        return map { $0.validate(rule: rule) }
    }
    
    func validate(rules: ValidationRuleSet<Value>) -> Property<ValidationResult> {
        return map { $0.validate(rules: rules) }
    }
}

extension Signal where Value: Validatable, Error == Never {
    func validate<Rule: ValidationRule>(rule: Rule) -> Signal<ValidationResult, Never> where Rule.InputType == Value {
        return map { $0.validate(rule: rule) }
    }
    
    func validate(rules: ValidationRuleSet<Value>) -> Signal<ValidationResult, Never> {
        return map { $0.validate(rules: rules) }
    }
}

extension SignalProducer where Value: Validatable, Error == Never {
    func validate<Rule: ValidationRule>(rule: Rule) -> SignalProducer<ValidationResult, Never>
        where Rule.InputType == Value {
            return map { $0.validate(rule: rule) }
    }
    
    func validate(rules: ValidationRuleSet<Value>) -> SignalProducer<ValidationResult, Never> {
        return map { $0.validate(rules: rules) }
    }
}

extension PropertyProtocol {
    static func merge<S: Sequence>(_ properties: S) -> Property<ValidationResult> where
        S.Iterator.Element: PropertyProtocol,
        S.Iterator.Element.Value == ValidationResult,
        Value == ValidationResult {
            
            return Self
                .combineLatest(properties)?
                .map { $0.first ?? .valid } ?? Property(value: .valid)
    }
}
