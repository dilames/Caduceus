//
//  ProfileCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import UIKit
import Domain

final class ProfileCoordinator: BaseCoordinator {
    
    private let profileViewController = R.storyboard.profile.profileViewController()!
    private let navigationController: BaseNavigationController
    
    private let useCases: UseCaseProvider
    private let user: User
    
    init(useCases: UseCaseProvider, navigationController: BaseNavigationController, user: User) {
        self.useCases = useCases
        self.navigationController = navigationController
        self.user = user
        super.init(rootController: profileViewController)
    }
    
    override func start() {
        configure(profileViewController)
        navigationController.pushViewController(profileViewController, animated: true)
    }
}

// MARK: - Controllers
extension ProfileCoordinator {
    private func configure(_ viewController: ProfileViewController) {
        let viewModel = ProfileViewModel(useCases: useCases, user: user)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
    }
}
