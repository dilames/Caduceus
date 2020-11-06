//
//  RegistrationViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/5/18.
//

import Foundation
import Domain
import ReactiveSwift
import ReactiveCocoa
import Result
import Validator

final class RegistrationFirstViewModel: ViewModel {
	
    // MARK: - Types
    
    typealias UseCases = HasSignUpUseCase
    
    struct Input {
        let phoneNumber: Signal<String, Never>
    }
    
    struct Output {
        let next: Action<Void, Void, AnyError>
        let close: ActionHandler
        let validations: Validations
    }
    
    struct Handlers {
        let next: Action<String, Void, Never>
        let close: ActionHandler
    }
    
    struct Validations {
        let phoneNumber: Property<[Error]>
    }
    
    // MARK: - Properties
    
    private let useCases: UseCases
    private let handlers: Handlers
    
    // MARK: - Lifecycle
    
    init(useCases: UseCases, handlers: Handlers) {
        self.useCases = useCases
        self.handlers = handlers
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    // MARK: - ViewModel Protocol
    
    func transform(_ input: Input) -> Output {
        let phoneNumber = Property(initial: "", then: input.phoneNumber)
        let isInputValid = self.isInputValid(input)
        let form = Property.combineLatest(phoneNumber, isInputValid)
        let nextAction = Action(state: form, execute: tryToRequestSmsCode)
        let closeAction: ActionHandler = .empty
        handlers.next <~ nextAction.values.skip(if: isInputValid.negate()).map { phoneNumber.value }
        handlers.close <~ closeAction.values
        let validations = self.validations(phone: phoneNumber, nextAction: nextAction)
        return Output(next: nextAction, close: closeAction, validations: validations)
    }
    
    private func validations(phone: Property<String>,
                             nextAction: Action<Void, Void, AnyError>) -> Validations {
        let phoneErrors = phone.producer
            .validate(rules: .phoneNumber(errorMessage: "Wrong phone number"))
            .map { $0.errors }
        let phoneErrorsAtTap = nextAction.values
            .withLatest(from: phoneErrors)
            .map { $1 }
        return Validations(phoneNumber: Property(initial: [], then: phoneErrorsAtTap))
    }
    
    private func isInputValid(_ input: Input) -> Property<Bool> {
        let isPhoneValid = input.phoneNumber
            .validate(rules: .phoneNumber())
            .map { $0.isValid }
        return Property(initial: false, then: isPhoneValid)
    }
    
    private func tryToRequestSmsCode(phone: String,
                                     isInputValid: Bool) -> SignalProducer<Void, AnyError> {
        if isInputValid {
            return useCases.signUp.requestSmsCode(for: phone)
        } else {
            return .executingEmpty
        }
    }
}
