//
//  RegistrationSecondViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/6/18.
//

import UIKit
import Domain
import ReactiveSwift
import Result
import Validator

final class RegistrationSecondViewModel: ViewModel {

    // MARK: - Types
    
    typealias UseCases = HasSignUpUseCase
    
    struct Input {
        let smsCode: Signal<String, Never>
        let password: Signal<String, Never>
        let confirmPassword: Signal<String, Never>
    }
    
    struct Output {
        let next: Action<Void, Void, AnyError>
        let complete: Action<Void, Void, AnyError>
        let sendAgain: Action<Void, Void, AnyError>
        let isSendAgainExecuting: Property<Bool>
        let validations: Validations
    }
    
    struct Handlers {
        let next: ActionHandler
        let complete: ActionHandler
        let sendAgain: Action<Void, PhoneConfirmationType?, Never>
    }
    
    struct Validations {
        let smsCode: Property<[Error]>
        let password: Property<[Error]>
        let confirmPassword: Property<[Error]>
    }
    
    // MARK: - Properties
    
    private let useCases: UseCases
    private let handlers: Handlers
    private let phoneNumber: String
    
    private var requestSms: Action<Void, Void, AnyError>?
    private var requestCall: Action<Void, Void, AnyError>?
    
    // MARK: - Lifecycle
    
    init(useCases: UseCases, handlers: Handlers, phoneNumber: String) {
        self.useCases = useCases
        self.handlers = handlers
        self.phoneNumber = phoneNumber
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    // MARK: - ViewModel Protocol
    
    func transform(_ input: Input) -> Output {
        let smsCode = Property(initial: "", then: input.smsCode)
        let password = Property(initial: "", then: input.password)
        let confirmPassword = Property(initial: "", then: input.confirmPassword)
        let isInputValid = self.isInputValid(input)
        let requestForm = Property.combineLatest(smsCode, password, isInputValid)
        
        let next = Action<Void, Void, AnyError>(execute:  { .executingEmpty })
        let complete = Action(state: requestForm, execute: tryToTakeSecondStep)
        requestSms = Action(state: Property(value: phoneNumber), execute: useCases.signUp.requestSmsCode)
        requestCall = Action(state: Property(value: phoneNumber), execute: useCases.signUp.requestCall)
        let sendAgain: Action<Void, Void, AnyError> = .empty
        
        handlers.next <~ next.values.skip(if: isInputValid.negate())
        handlers.complete <~ complete.values.skip(if: isInputValid.negate())
        handlers.sendAgain <~ sendAgain.values
        
        var isSendAgainExecuting = Property(value: false)
        
        if let requestSms = requestSms, let requestCall = requestCall {
            requestSms <~ handlers.sendAgain.values.skipNil().filter { $0 == .message }.mapToVoid()
            requestCall <~ handlers.sendAgain.values.skipNil().filter { $0 == .call }.mapToVoid()
            let executingSignal = Signal.merge(requestCall.isExecuting.signal, requestSms.isExecuting.signal)
            isSendAgainExecuting = Property.init(initial: false, then: executingSignal)
        }
        
        let validations = self.validations(
            smsCode: smsCode, password: password,
            confirmPassword: confirmPassword, nextAction: next, completeAction: complete)
        return Output(
            next: next,
            complete: complete,
            sendAgain: sendAgain,
            isSendAgainExecuting: isSendAgainExecuting,
            validations: validations
        )
    }
    
    private func validations(smsCode: Property<String>,
                             password: Property<String>,
                             confirmPassword: Property<String>,
                             nextAction: Action<Void, Void, AnyError>,
                             completeAction: Action<Void, Void, AnyError>) -> Validations {
        let actionsValues = Signal.merge(nextAction.values, completeAction.values)
        let codeErrors = smsCode.producer
        	.validate(rules: .required)
            .map { $0.errors }
        let passwordErrors = password.producer
        	.validate(rules: .password(errorMessage: "Wrong Password"))
            .map { $0.errors }
        let confirmPasswordErrors = SignalProducer
            .combineLatest(password, confirmPassword)
            .map { Passwords(password: $0, confirmPassword: $1) }
            .validate(rules: .comparison({ $0.password == $0.confirmPassword },
                                         errorMessage: "Passwords don't match"))
            .map { $0.errors }
        let codeErrorsAtTap = actionsValues
        	.withLatest(from: codeErrors)
            .map { $1 }
        let passwordErrorsAtTap = actionsValues
        	.withLatest(from: passwordErrors)
            .map { $1 }
        let confirmPasswordErrorsAtTap = actionsValues
        	.withLatest(from: confirmPasswordErrors)
            .map { $1 }
        return Validations(smsCode: Property(initial: [], then: codeErrorsAtTap),
                           password: Property(initial: [], then: passwordErrorsAtTap),
                           confirmPassword: Property(initial: [], then: confirmPasswordErrorsAtTap))
    }
    
    private func isInputValid(_ input: Input) -> Property<Bool> {
        let isCodeValid = input.smsCode
            .validate(rules: .required)
            .map { $0.isValid }
        let isPasswordValid = input.password
        	.validate(rules: .password())
            .map { $0.isValid }
        let isConfirmPasswordValid = Signal
            .combineLatest(input.password, input.confirmPassword)
            .map { Passwords(password: $0, confirmPassword: $1) }
        	.validate(rules: .comparison({ $0.password == $0.confirmPassword }))
            .map { $0.isValid }
        let isInputValid = isCodeValid.and(isPasswordValid).and(isConfirmPasswordValid)
        return Property(initial: false, then: isInputValid)
    }
    
    private func tryToTakeSecondStep(smsCode: String,
                                     password: String,
                                     isInputValid: Bool) -> SignalProducer<Void, AnyError> {
        if isInputValid {
            let form = SignUpSecondStepForm(phoneNumber: phoneNumber, smsCode: smsCode,
                                            password: password, confirmPassword: password)
            return useCases.signUp.takeSecondStep(form: form)
        } else {
            return .executingEmpty
        }
    }
}

private struct Passwords: Validatable {
    let password: String
    let confirmPassword: String
}
