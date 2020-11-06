//
//  RegistrationCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/30/18.
//

import UIKit
import Domain
import ReactiveSwift
import Result

final class RegistrationCoordinator: BaseCoordinator {

    typealias FinishAction = Action<BaseCoordinator, Void, Never>
    
    let useCases: UseCaseProvider
    let sourceController: UIViewController
    let navigationController: StepNavigationController
    
    let finishRegistration: ActionHandler
    
    init(useCases: UseCaseProvider,
         sourceController: UIViewController,
         finishRegistration: ActionHandler)
    {
        self.useCases = useCases
        self.sourceController = sourceController
        self.finishRegistration = finishRegistration
        navigationController = StepNavigationController(shouldRoundCorners: true)
        super.init(rootController: navigationController)
        reactive.finish() <~ finishRegistration.values
    }
    
    override func start() {
        navigationController.numberOfSteps = 4
        let controller = registrationFirstController
        navigationController.pushViewController(controller, animated: false)
        navigationController.showStepView()
        controller.reactive.viewWillAppear.observeValues { [weak self] _ in
            self?.navigationController.setStepIndex(0)
        }
        sourceController.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Controllers
extension RegistrationCoordinator {
    var registrationFirstController: RegistrationFirstViewController {
        let handlers = RegistrationFirstViewModel.Handlers(next: openRegistrationSecond(), close: closeRegistration())
        let viewModel = RegistrationFirstViewModel(useCases: useCases, handlers: handlers)
        let controller = R.storyboard.auth.registrationFirstViewController()!
        controller.viewModel = viewModel
        return controller
    }
    
    func registrationSecondController(phoneNumber: String) -> RegistrationSecondViewController {
        let handlers = RegistrationSecondViewModel.Handlers(
            next: openRegistrationThird(),
            complete: finishRegistration,
            sendAgain: openPhoneConfirmationPicker())
        let viewModel = RegistrationSecondViewModel(useCases: useCases, handlers: handlers, phoneNumber: phoneNumber)
        let controller = R.storyboard.auth.registrationSecondViewController()!
        controller.viewModel = viewModel
        return controller
    }
    
    var registrationThirdController: RegistrationThirdViewController {
        let handlers = RegistrationThirdViewModel.Handlers(birthDate: openDatePicker(), next: openRegistrationFourth())
        let viewModel = RegistrationThirdViewModel(useCases: useCases, handlers: handlers)
        let controller = R.storyboard.auth.registrationThirdViewController()!
        controller.viewModel = viewModel
        return controller
    }
    
    var registrationFourthController: RegistrationFourthViewController {
        let handlers = RegistrationFourthViewModel.Handlers(
            didTapFirstQuestion: openQuestionsAutocomplete(),
            didTapSecondQuestion: openQuestionsAutocomplete(),
            didTapThirdQuestion: openQuestionsAutocomplete(),
            next: finishRegistration)
        let viewModel = RegistrationFourthViewModel(useCases: useCases, handlers: handlers)
        let controller = R.storyboard.auth.registrationFourthViewController()!
        controller.viewModel = viewModel
        return controller
    }
    
    func secretQuestions(selected: String?, observer: Signal<String?, Never>.Observer) -> SecretQuestionsViewController {
        let handlers = SecretQuestionsViewModel.Handlers(done: closeQuestionsAutocomplete())
        let viewModel = SecretQuestionsViewModel(useCases: useCases, handlers: handlers, selectedQuestion: selected, observer: observer)
        let controller = R.storyboard.auth.secretQuestionsViewController()!
        controller.viewModel = viewModel
        return controller
    }
}

// MARK: - Handlers
extension RegistrationCoordinator {
    func openRegistrationSecond() -> Action<String, Void, Never> {
        return Action(execute: { [weak self] (phoneNumber) -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let controller = strongSelf.registrationSecondController(phoneNumber: phoneNumber)
            controller.reactive.viewWillAppear.observeValues { _ in
                strongSelf.navigationController.setStepIndex(1)
            }
            return strongSelf.navigationController.reactive.pushViewController(controller, animated: true)
        })
    }
    
    func openRegistrationThird() -> ActionHandler {
        return Action(execute: { [weak self] () -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let controller = strongSelf.registrationThirdController
            controller.reactive.viewWillAppear.observeValues { _ in
                strongSelf.navigationController.setStepIndex(2)
            }
            return strongSelf.navigationController.reactive.pushViewController(controller, animated: true)
        })
    }
    
    func openRegistrationFourth() -> ActionHandler {
        return Action(execute: { [weak self] () -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let controller = strongSelf.registrationFourthController
            controller.reactive.viewWillAppear.observeValues { _ in
                strongSelf.navigationController.setStepIndex(3)
            }
            return strongSelf.navigationController.reactive.pushViewController(controller, animated: true)
        })
    }
    
    func openQuestionsAutocomplete() -> Action<String?, String?, Never> {
        return Action(execute: { [weak self] (selectedQuestion) -> SignalProducer<String?, Never> in
            guard let strongSelf = self else { return .empty }
            return SignalProducer { observer, _ in
                let controller = strongSelf.secretQuestions(selected: selectedQuestion, observer: observer)
                controller.reactive.viewWillAppear.observeValues { _ in
                    strongSelf.navigationController.hideStepView(animated: true)
                }
                controller.reactive.viewWillDisappear.observeValues { _ in
                    strongSelf.navigationController.showStepView(animated: true)
                }
                strongSelf.navigationController.pushViewController(controller, animated: true)
            }
        })
    }
    
    func closeQuestionsAutocomplete() -> Action<Void, Void, Never> {
        return Action(execute: { [weak self] (_) -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            return strongSelf.navigationController.reactive.popViewController(animated: true).mapToVoid()
        })
    }
    
    func openPhoneConfirmationPicker() -> Action<Void, PhoneConfirmationType?, Never> {
        return Action(execute: { [weak self] (_) -> SignalProducer<PhoneConfirmationType?, Never> in
            guard let strongSelf = self else { return .empty }
            return SignalProducer { observer, _ in
                let picker = UIAlertController.confirmPhoneType(handler: { type in
                    observer.send(value: type)
                    observer.sendCompleted()
                })
                strongSelf.navigationController.present(picker, animated: true, completion: nil)
            }
        })
    }
    
    func openDatePicker() -> Action<Date?, Date?, Never> {
        return Action(execute: { [weak self] (selectedDate) -> SignalProducer<Date?, Never> in
            guard let strongSelf = self else { return .empty }
            return SignalProducer { observer, _ in
                let datePicker = UIAlertController.datePicker(selected: selectedDate, date: { date in
                    observer.send(value: date)
                    observer.sendCompleted()
                })
                strongSelf.navigationController.present(datePicker, animated: true, completion: nil)
            }
        })
    }
    
    func closeRegistration() -> ActionHandler {
        return Action { [weak self] () -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            return strongSelf.reactive.finish()
        }
    }
}
