//
//  RegistrationFourthViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/6/18.
//

import Domain
import ReactiveSwift
import ReactiveCocoa
import Result
import Validator

final class RegistrationFourthViewModel: ViewModel {

    // MARK: - Types
    
    typealias UseCases = HasSignUpUseCase
    
    struct Input {
        let firstAnswer: Signal<String, Never>
        let secondAnswer: Signal<String, Never>
        let thirdAnswer: Signal<String, Never>
    }
    
    struct Output {
        let didTapFirstQuestion: Action<String?, String?, Never>
        let didTapSecondQuestion: Action<String?, String?, Never>
        let didTapThirdQuestion: Action<String?, String?, Never>
        let firstQuestion: Property<String?>
        let secondQuestion: Property<String?>
        let thirdQuestion: Property<String?>
        let validations: Validations
        let next: Action<Void, Void, AnyError>
    }
    
    struct Validations {
        let firstAnswer: Property<[Error]>
        let secondAnswer: Property<[Error]>
        let thirdAnswer: Property<[Error]>
    }
    
    struct Handlers {
        let didTapFirstQuestion: Action<String?, String?, Never>
        let didTapSecondQuestion: Action<String?, String?, Never>
        let didTapThirdQuestion: Action<String?, String?, Never>
        let next: ActionHandler
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
        let isInputValid = self.isInputValid(input)
        let firstQuestion = MutableProperty("")
        let secondQuestion = MutableProperty("")
        let thirdQuestion = MutableProperty("")
        
        firstQuestion <~ handlers.didTapFirstQuestion.values.map { $0 ?? firstQuestion.value }
        secondQuestion <~ handlers.didTapSecondQuestion.values.map { $0 ?? secondQuestion.value }
        thirdQuestion <~ handlers.didTapThirdQuestion.values.map { $0 ?? thirdQuestion.value }
        
        let firstAnswer = Property(initial: "", then: input.firstAnswer)
        let secondAnswer = Property(initial: "", then: input.secondAnswer)
        let thirdAnswer = Property(initial: "", then: input.thirdAnswer)
        
        let form = Property
            .combineLatest(firstQuestion, firstAnswer, secondQuestion,
                           secondAnswer, thirdQuestion, thirdAnswer)
            .map { UpdateSecretForm($0) }
        let requestForm = Property.combineLatest(form, isInputValid)
        let next = Action(state: requestForm, execute: tryToTakeFourthStep)
        handlers.next <~ next.values.skip(if: isInputValid.negate())
        
        let validations = self.validations(firstAnswer: firstAnswer, secondAnswer: secondAnswer,
                                           thirdAnswer: thirdAnswer, next: next)
        
        return Output(
            didTapFirstQuestion: handlers.didTapFirstQuestion,
            didTapSecondQuestion: handlers.didTapSecondQuestion,
            didTapThirdQuestion: handlers.didTapThirdQuestion,
            firstQuestion: Property(firstQuestion).optional,
            secondQuestion: Property(secondQuestion).optional,
            thirdQuestion: Property(thirdQuestion).optional,
            validations: validations,
            next: next
        )
    }
    
    private func isInputValid(_ input: Input) -> Property<Bool> {
        let firstAnswerValid = input.firstAnswer.validate(rules: .required).map { $0.isValid }
        let secondAnswerValid = input.secondAnswer.validate(rules: .required).map { $0.isValid }
        let thirdAnswerValid = input.thirdAnswer.validate(rules: .required).map { $0.isValid }
        let isInputValid = firstAnswerValid.and(secondAnswerValid).and(thirdAnswerValid)
        return Property(initial: false, then: isInputValid)
    }
    
    private func validations(firstAnswer: Property<String>,
                             secondAnswer: Property<String>,
                             thirdAnswer: Property<String>,
                             next: Action<Void, Void, AnyError>) -> Validations {
        let firstErrors = firstAnswer.producer.validate(rules: .required).map { $0.errors }
        let secondErrors = secondAnswer.producer.validate(rules: .required).map { $0.errors }
        let thirdErrors = thirdAnswer.producer.validate(rules: .required).map { $0.errors }
        let firstErrorsAtTap = next.values.withLatest(from: firstErrors).map { $1 }
        let secondErrorsAtTap = next.values.withLatest(from: secondErrors).map { $1 }
        let thirdErrorsAtTap = next.values.withLatest(from: thirdErrors).map { $1 }
        return Validations(
            firstAnswer: Property(initial: [], then: firstErrorsAtTap),
            secondAnswer: Property(initial: [], then: secondErrorsAtTap),
            thirdAnswer: Property(initial: [], then: thirdErrorsAtTap))
    }
    
    private func tryToTakeFourthStep(form: UpdateSecretForm,
                                     isInputValid: Bool) -> SignalProducer<Void, AnyError> {
        if isInputValid {
            return useCases.signUp.takeFourthStep(form: form)
        } else {
            return .executingEmpty
        }
    }
}
