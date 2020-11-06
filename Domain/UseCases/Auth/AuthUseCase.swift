//
//  AuthUseCase.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol AuthUseCase {
    func requestSmsCode(to phoneNumber: String, password: String) -> SignalProducer<Void, AnyError>
    func requestCall(for phoneNumber: String, password: String) -> SignalProducer<Void, AnyError>
    func send(smsCode: String, password: String, phone: String) -> SignalProducer<Void, AnyError>
}

public protocol HasAuthUseCase {
    var auth: AuthUseCase { get }
}
