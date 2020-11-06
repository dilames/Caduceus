//
//  LoginCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/30/18.
//

import UIKit
import Domain
import ReactiveSwift
import Result

final class LoginCoordinator: BaseCoordinator {
    
    typealias FinishAction = Action<BaseCoordinator, Void, Never>

    let useCases: UseCaseProvider
    let sourceController: UIViewController
    let navigationController: StepNavigationController
    let finishAutorization: ActionHandler

    init(useCases: UseCaseProvider,
         sourceController: UIViewController,
         finishAutorization: ActionHandler)
    {
        self.useCases = useCases
        self.sourceController = sourceController
        self.finishAutorization = finishAutorization
        navigationController = StepNavigationController(shouldRoundCorners: true)
        super.init(rootController: navigationController)
        reactive.finish() <~ finishAutorization.values
    }
    
    override func start() {
        let signInController = self.signInController
     	navigationController.numberOfSteps = 2
        navigationController.pushViewController(signInController, animated: false)
        navigationController.showStepView()
        signInController.reactive.viewWillAppear.observeValues { [weak self] _ in
            self?.navigationController.setStepIndex(0)
        }
        sourceController.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Controllers
extension LoginCoordinator {
    var signInController: EnterPhoneViewController {
        let handlers = EnterPhoneViewModel.Handlers(next: openPhoneConfirmation(), close: closeLogin())
        let viewModel = EnterPhoneViewModel(useCases: useCases, handlers: handlers)
        let controller = R.storyboard.auth.enterPhoneViewController()!
        controller.viewModel = viewModel
        return controller
    }
    
    func phoneConfirmationController(phone: String, password: String) -> PhoneConfirmationViewController {
        let handlers = PhoneConfirmationViewModel.Handlers(next: finishAutorization, sendAgain: openPhoneConfirmationPicker())
        let viewModel = PhoneConfirmationViewModel(useCases: useCases, handlers: handlers,
                                                   phoneNumber: phone, password: password)
        let controller = R.storyboard.auth.phoneConfirmationViewController()!
        controller.viewModel = viewModel
        return controller
    }
}

// MARK: - Handlers
extension LoginCoordinator {
    func openPhoneConfirmation() -> Action<(phone: String, password: String), Void, Never> {
        return Action(execute: { [weak self] (input) -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let controller = strongSelf.phoneConfirmationController(phone: input.phone, password: input.password)
            controller.reactive.viewWillAppear.observeValues { _ in
                strongSelf.navigationController.setStepIndex(1)
            }
            return strongSelf.navigationController.reactive.pushViewController(controller, animated: true)
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
    
    func closeLogin() -> ActionHandler {
        return Action { [weak self] () -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            return strongSelf.reactive.finish()
        }
    }
}
