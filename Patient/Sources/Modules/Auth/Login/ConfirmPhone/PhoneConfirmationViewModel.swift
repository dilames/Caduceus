//
//  PhoneConfirmationViewModel.swift
//  Patient
//
//  Created by Andrew Chersky on 3/24/18.
//

import Foundation
import Domain
import ReactiveSwift
import Result
import Validator

final class PhoneConfirmationViewModel: ViewModel {
    
    // MARK: - Types
    
    typealias UseCases = HasAuthUseCase
    
    struct Input {
        let smsCode: Signal<String, Never>
    }
    
    struct Output {
        let next: Action<Void, Void, AnyError>
        let sendAgain: Action<Void, Void, AnyError>
        let isSendAgainExecuting: Property<Bool>
        let validations: Validations
    }
    
    struct Validations {
        let smsCode: Property<[Error]>
    }
    
    struct Handlers {
        let next: Action<Void, Void, Never>
        let sendAgain: Action<Void, PhoneConfirmationType?, Never>
    }
    
    // MARK: - Properties
    
    private let useCases: UseCases
    private let handlers: Handlers
    private let phoneNumber: String
    private let password: String
    
    private var requestSms: Action<Void, Void, AnyError>?
    private var requestCall: Action<Void, Void, AnyError>?
    
    // MARK: - Lifecycle
    
    init(useCases: UseCases, handlers: Handlers, phoneNumber: String, password: String) {
        self.useCases = useCases
        self.handlers = handlers
        self.phoneNumber = phoneNumber
        self.password = password
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    // MARK: - ViewModel Protocol
    
    func transform(_ input: Input) -> Output {
        let codeProperty = Property(initial: "", then: input.smsCode)
        let phoneProperty = Property(value: phoneNumber)
        let paswordProperty = Property(value: password)
        let isInputValid = self.isInputValid(input)
        
        let form = Property.combineLatest(codeProperty, phoneProperty, paswordProperty, isInputValid)
        let confirmAction = Action(state: form, execute: tryToSendSmsCode)
        let sendAgain: Action<Void, Void, AnyError> = .empty
        
        requestSms = Action(state: Property(value: (phoneNumber, password)), execute: useCases.auth.requestSmsCode)
        requestCall = Action(state: Property(value: (phoneNumber, password)), execute: useCases.auth.requestCall)
        
        handlers.next <~ confirmAction.values.skip(if: isInputValid.negate())
        handlers.sendAgain <~ sendAgain.values
        
        var isSendAgainExecuting = Property(value: false)
        
        if let sms = requestSms, let call = requestCall {
            sms <~ handlers.sendAgain.values.skipNil().filter { $0 == .message }.mapToVoid()
            call <~ handlers.sendAgain.values.skipNil().filter { $0 == .call }.mapToVoid()
            let activitySignal = Signal.merge(sms.isExecuting.signal, call.isExecuting.signal)
            isSendAgainExecuting = Property(initial: false, then: activitySignal)
        }
        
        let validations = self.validations(code: codeProperty, nextAction: confirmAction)
        return Output(next: confirmAction,
                      sendAgain: sendAgain,
                      isSendAgainExecuting: isSendAgainExecuting,
                      validations: validations)
    }
    
    private func validations(code: Property<String>,
                             nextAction: Action<Void, Void, AnyError>) -> Validations {
        let codeErrors = code.producer
        	.validate(rules: .required)
            .map { $0.errors }
        let codeAtTap = nextAction.values
            .withLatest(from: codeErrors)
            .map { $1 }
        return Validations(smsCode: Property(initial: [], then: codeAtTap))
    }
    
    private func isInputValid(_ input: Input) -> Property<Bool> {
        let isCodeValid = input.smsCode
        	.validate(rules: .required)
            .map { $0.isValid }
        return Property(initial: false, then: isCodeValid)
    }
    
    private func tryToSendSmsCode(code: String,
                                  phone: String,
                                  password: String,
                                  isInputValid: Bool) -> SignalProducer<Void, AnyError> {
        if isInputValid {
            return useCases.auth.send(smsCode: code, password: password, phone: phone)
        } else {
            return .executingEmpty
        }
    }
}
