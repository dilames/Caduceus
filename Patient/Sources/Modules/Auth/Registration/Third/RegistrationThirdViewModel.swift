//
//  RegistrationThirdViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/6/18.
//

import UIKit
import Domain
import ReactiveSwift
import ReactiveCocoa
import Result

final class RegistrationThirdViewModel: ViewModel {

    typealias UseCases = HasSignUpUseCase
    
    struct Input {
        let firstName: Signal<String, Never>
        let lastName: Signal<String, Never>
        let patronymic: Signal<String, Never>
        let genderIndex: Signal<Int, Never>
        let email: Signal<String, Never>
    }
    
    struct Output {
        let next: Action<Void, Void, AnyError>
        let birthDate: Action<Date?, Date?, Never>
        let selectedDate: Property<Date?>
    }
    
    struct Handlers {
        let birthDate: Action<Date?, Date?, Never>
        let next: ActionHandler
    }
    
    private let useCases: UseCases
    private let handlers: Handlers
    
    init(useCases: UseCases, handlers: Handlers) {
        self.useCases = useCases
        self.handlers = handlers
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func transform(_ input: Input) -> Output {
        let genderSignal = input.genderIndex.map {$0 == 0 ? Gender.male : Gender.female}
        let firstName = Property(initial: "", then: input.firstName).optional
        let lastName = Property(initial: "", then: input.lastName).optional
        let patronymic = Property(initial: "", then: input.patronymic).optional
        let gender = Property<Gender?>(initial: .male, then: genderSignal)
        let email = Property(initial: "", then: input.email).optional
        let birthDate = MutableProperty<Date?>(nil)
        
        let form = Property
            .combineLatest(firstName, lastName, patronymic, gender, email, birthDate)
            .map { UpdatePersonForm($0) }

        let next = Action<Void, Void, AnyError>(execute: { _ in .executingEmpty })
        handlers.next <~ next.values
        birthDate <~ handlers.birthDate.values.map { $0 ?? birthDate.value }
        
        return Output(
            next: next,
            birthDate: handlers.birthDate,
            selectedDate: Property(birthDate)
        )
    }
}
