//
//  EnterPhoneViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import UIKit
import Domain
import ReactiveSwift
import ReactiveCocoa
import Result
import Validator

final class EnterPhoneViewModel: ViewModel {

    // MARK: - Types
    
    typealias UseCases = HasAuthUseCase
    typealias NextInput = (phone: String, password: String)
    
    struct Input {
        let phone: Signal<String, Never>
        let password: Signal<String, Never>
    }
    
    struct Output {
        let next: Action<Void, Void, AnyError>
        let close: ActionHandler
        let validations: Validations
    }
    
    struct Handlers {
        let next: Action<NextInput, Void, Never>
        let close: ActionHandler
    }
    
    struct Validations {
        let phone: Property<[Error]>
        let password: Property<[Error]>
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
        let phone = Property(initial: "", then: input.phone)
        let password = Property(initial: "", then: input.password)
        let isInputValid = self.isInputValid(input)
        
        let form = Property.combineLatest(phone, password, isInputValid)
        let next = Action(state: form, execute: tryToRequestSmsCode)
        let close = ActionHandler.empty
        
        handlers.next <~ next.values
            .skip(if: isInputValid.negate())
            .map { NextInput(phone.value, password.value) }
        handlers.close <~ close.values
        
        let validations = self.validations(phone: phone, password: password, nextAction: next)
        return Output(next: next, close: close, validations: validations)
    }
    
    private func validations(phone: Property<String>,
                             password: Property<String>,
                             nextAction: Action<Void, Void, AnyError>) -> Validations {
        let phoneErrors = phone.producer
            .validate(rules: .phoneNumber(errorMessage: "Wrong Phone number"))
            .map { $0.errors }
        let passwordErrors = password.producer
            .validate(rules: .password(errorMessage: "Wrong password"))
            .map { $0.errors } 
        let phoneErrorsAtTap = nextAction.values
            .withLatest(from: phoneErrors)
            .map { $1 }
        let passwordErrorsAtTap = nextAction.values
            .withLatest(from: passwordErrors)
            .map { $1 }
        return Validations(
            phone: Property(initial: [], then: phoneErrorsAtTap),
            password: Property(initial: [], then: passwordErrorsAtTap))
    }
    
    private func isInputValid(_ input: Input) -> Property<Bool> {
        let isPhoneValid = input.phone
            .validate(rules: .phoneNumber())
            .map { $0.isValid }
        let isPasswordValid = input.password
        	.validate(rules: .password())
            .map { $0.isValid }
        let isInputValidSignal = isPhoneValid.and(isPasswordValid)
        return Property(initial: false, then: isInputValidSignal)
    }
    
    private func tryToRequestSmsCode(phone: String,
                                     password: String,
                                     isInputValid: Bool) -> SignalProducer<Void, AnyError> {
        if isInputValid {
            return useCases.auth.requestSmsCode(to: phone, password: password)
        } else {
            return .executingEmpty
        }
    }
}
