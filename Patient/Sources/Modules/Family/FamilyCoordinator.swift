//
//  FamilyCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import UIKit
import Domain
import ReactiveSwift
import Result

final class FamilyCoordinator: BaseCoordinator {

    private let navigationController: BaseNavigationController
    private let familyViewController: FamilyListViewController
    
    private let useCases: UseCaseProvider
    
    init(navigationController: BaseNavigationController, useCases: UseCaseProvider) {
        self.navigationController = navigationController
        self.useCases = useCases
        familyViewController = R.storyboard.family.familyListViewController()!
        super.init(rootController: familyViewController)
    }
    
    override func start() {
        configure(familyViewController)
        navigationController.pushViewController(familyViewController, animated: true)
    }
}

// MARK: - Controllers
extension FamilyCoordinator {
    private func configure(_ viewController: FamilyListViewController) {
        let handlers = FamilyListViewModel.Handlers(
            didSelectUser: didSelectListedUser,
            didTapAddNewMember: didTapAddNewMember)
        let viewModel = FamilyListViewModel(useCases: useCases, handlers: handlers)
        familyViewController.viewModel = viewModel
        familyViewController.hidesBottomBarWhenPushed = true
    }
    
    private var searchUsersController: SearchUserViewController {
        let viewController = R.storyboard.family.searchUserViewController()!
        let handlers = SearchUserViewModel.Handlers(
            didSelectUser: didAddNewFamilyMember,
            didTapOpenProfile: didSelectListedUser)
        let viewModel = SearchUserViewModel(useCases: useCases, handlers: handlers)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: - Handlers
extension FamilyCoordinator {
    var didSelectListedUser: Action<User, Void, Never> {
        return Action { [weak self] in
            guard let strongSelf = self else { return .empty }
            let profileCoordinator = ProfileCoordinator(
                useCases: strongSelf.useCases,
                navigationController: strongSelf.navigationController,
                user: $0)
            strongSelf.add(profileCoordinator)
            return profileCoordinator.reactive.start()
        }
    }
    
    var didTapAddNewMember: ActionHandler {
        return Action { [weak self] in
            guard let strongSelf = self else { return .empty }
            let controller = strongSelf.searchUsersController
            return strongSelf.navigationController.reactive.pushViewController(controller)
        }
    }
    
    var didAddNewFamilyMember: Action<User, Void, Never> {
        return Action(execute: { [weak self] (_) -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            return strongSelf.navigationController.reactive
                .popViewController(animated: true)
                .mapToVoid()
        })
    }
}
