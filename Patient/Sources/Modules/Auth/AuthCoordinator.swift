//
//  AuthCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Foundation
import Domain
import ReactiveSwift
import Result

final class AuthCoordinator: BaseCoordinator {
    
    private let useCases: UseCaseProvider
    private let _rootController: StartScreenViewController
    private let openMainFlow: Action<Void, Void, Never>
    
    init(
        rootController: StartScreenViewController = R.storyboard.auth.startScreenViewController()!,
        useCases: UseCaseProvider,
        openMainFlow: ActionHandler)
    {
        self._rootController = rootController
        self.useCases = useCases
        self.openMainFlow = openMainFlow
        super.init(rootController: rootController)
    }
    
    override func start() {
        let handlers = StartScreenViewModel.Handlers(
            login: openLogin(),
            register: openRegistration(),
            enterAsGuest: openMainFlow)
        let viewModel = StartScreenViewModel(handlers: handlers)
        _rootController.viewModel = viewModel
    }
}

// MARK: - Handlers
extension AuthCoordinator {
    func openLogin() -> ActionHandler {
        return Action { [weak self] () -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let loginCoordinator = LoginCoordinator(
                useCases: strongSelf.useCases,
                sourceController: strongSelf.rootController,
                finishAutorization: strongSelf.openMainFlow)
            strongSelf.add(loginCoordinator)
            loginCoordinator.start()
            return .executingEmpty
        }
    }
    
    func openRegistration() -> ActionHandler {
        return Action { [weak self] () -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let registrationCoordinator = RegistrationCoordinator(
                useCases: strongSelf.useCases,
                sourceController: strongSelf.rootController,
                finishRegistration: strongSelf.openMainFlow)
            strongSelf.add(registrationCoordinator)
            registrationCoordinator.start()
            return .executingEmpty
        }
    }
}
