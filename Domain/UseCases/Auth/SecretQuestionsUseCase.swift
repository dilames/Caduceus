//
//  SecretQuestionsUseCase.swift
//  Domain
//
//  Created by Andrew Chersky  on 3/8/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol SecretQuestionsUseCase {
    func fetch() -> SignalProducer<[String], AnyError>
}

public protocol HasSecretQuestionsUseCase {
    var secretQuestions: SecretQuestionsUseCase { get }
}
