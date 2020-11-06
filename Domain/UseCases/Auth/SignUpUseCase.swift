//
//  RegistrationUseCase.swift
//  Domain
//
//  Created by Andrew Chersky  on 3/6/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol SignUpUseCase {
    func requestSmsCode(for phoneNumber: String) -> SignalProducer<Void, AnyError>
    func requestCall(for phoneNumber: String) -> SignalProducer<Void, AnyError>
    func takeSecondStep(form: SignUpSecondStepForm) -> SignalProducer<Void, AnyError>
    func takeThirdStep(form: UpdatePersonForm) -> SignalProducer<Void, AnyError>
    func takeFourthStep(form: UpdateSecretForm) -> SignalProducer<Void, AnyError>
}

public protocol HasSignUpUseCase {
    var signUp: SignUpUseCase { get }
}
