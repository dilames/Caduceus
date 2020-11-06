//
//  SettingsCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky on 5/18/18.
//

import Foundation
import ReactiveSwift
import Result
import Domain

final class SettingsCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private let settingsViewController = R.storyboard.settings.settingsController()!
    private let useCases: UseCaseProvider
    
    init(navigationController: UINavigationController, useCases: UseCaseProvider) {
        self.navigationController = navigationController
        self.useCases = useCases
        super.init(rootController: settingsViewController)
    }
    
    override func start() {
        settingsViewController.hidesBottomBarWhenPushed = true
        let handlers = SettingsViewModel.Handlers(didTapEditProfile: didTapEditProfile(),
                                                  didTapChooseMapStyle: didTapChooseMapStyle())
        settingsViewController.viewModel = SettingsViewModel(handlers: handlers, useCases: useCases)
        navigationController.pushViewController(settingsViewController, animated: false)
    }
}

// MARK: Handlers
extension SettingsCoordinator {
    private func didTapEditProfile() -> ActionHandler {
        return Action {
            return .executingEmpty
        }
    }
    private func didTapChooseMapStyle() -> ActionHandler {
        return Action { [weak self] in
            guard let strongSelf = self else { return .executingEmpty }
            let controller = R.storyboard.settings.chooseMapController()!
            let handlers = ChooseMapViewModel.Handlers(didSelectMapStyle: strongSelf.didSelectMapStyle())
            controller.viewModel = ChooseMapViewModel(useCases: strongSelf.useCases, handlers: handlers)
            return strongSelf.navigationController.reactive.pushViewController(controller)
        }
    }
    private func didSelectMapStyle() -> ActionHandler {
        return Action { [weak self] in
            guard let strongSelf = self else { return .executingEmpty }
            return strongSelf.navigationController.reactive.popViewController(animated: true).mapToVoid()
        }
    }
}
