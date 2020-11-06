//
//  SideMenuCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import UIKit
import Domain
import ReactiveSwift
import Result
import SideMenu
import Domain

final class SideMenuCoordinator: BaseCoordinator {
    
    private let menuNavigationController: UISideMenuNavigationController
    private var disposables: [Disposable] = []
    private let useCases: UseCaseProvider
    
    var sourceNavigationController: SideNavigationController {
        didSet {
            observeMenuItemSelection()
        }
    }
    
    init(sourceNavigationController: SideNavigationController, useCases: UseCaseProvider) {
        self.sourceNavigationController = sourceNavigationController
        self.useCases = useCases
        menuNavigationController = UISideMenuNavigationController(nibName: nil, bundle: nil)
        super.init(rootController: menuNavigationController)
    }

    override func start() {
        SideMenuManager.default.menuLeftNavigationController = menuNavigationController
        menuNavigationController.setNavigationBarHidden(true, animated: false)
        let handlers = SideMenuViewModel.Handlers(didSelectItem: didSelectMenuItem())
        let viewModel = SideMenuViewModel(handlers: handlers)
        let sideMenu = R.storyboard.main.sideMenuController()!
        sideMenu.viewModel = viewModel
        menuNavigationController.pushViewController(sideMenu, animated: false)
        configureSideMenu()
        observeMenuItemSelection()
    }
    
    private func configureSideMenu() {
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAnimationBackgroundColor = .clear
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.width * 0.8
        SideMenuManager.default.menuShadowColor = .black
        SideMenuManager.default.menuShadowOpacity = 0.2
        SideMenuManager.default.menuShadowRadius = 10
    }
    
    private func observeMenuItemSelection() {
        disposables.forEach {$0.dispose()}
        disposables.removeAll()
        let disposable = sourceNavigationController.reactive.menuItemSelection
            .take(during: rootController.reactive.lifetime)
            .observeValues { [weak self] in
                guard
                    let strongSelf = self,
                    let menuNavigationController = SideMenuManager.default.menuLeftNavigationController else {
                        return
                }
                strongSelf.sourceNavigationController.present(menuNavigationController, animated: true, completion: nil)
        }
        if let disposable = disposable {
        	disposables.append(disposable)
        }
    }
}

// MARK: - Controllers
extension SideMenuCoordinator {
    var profileController: UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .white
        controller.title = "Needed controller"
        return controller
    }
    
    func coordinator(with sideMenuCellViewModel: SideMenuCellViewModel) -> BaseCoordinator {
        let baseCoordinator: BaseCoordinator
        switch sideMenuCellViewModel {
        case .profile:
            guard let user = useCases.currentUser.currentUser.value.user else {
                fatalError("No user")
            }
            baseCoordinator = ProfileCoordinator(useCases: useCases,
                                                 navigationController: sourceNavigationController,
                                                 user: user)
        case .settings:
            baseCoordinator = SettingsCoordinator(navigationController: sourceNavigationController,
                                                  useCases: useCases)
        case .family:
            baseCoordinator = FamilyCoordinator(navigationController: sourceNavigationController,
                                                useCases: useCases)
        }
        add(baseCoordinator)
        return baseCoordinator
    }
}

// MARK: - Handlers
extension SideMenuCoordinator {
    private func didSelectMenuItem() -> Action<SideMenuCellViewModel, Void, Never> {
        return Action { [weak self] (cellViewModel) -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let closeMenu = SideMenuManager.default.menuLeftNavigationController?
                .reactive.dismiss(animated: true) ?? .empty
            let targetCoordinator = strongSelf.coordinator(with: cellViewModel)
            return SignalProducer
                .combineLatest(targetCoordinator.reactive.start(), closeMenu)
                .mapToVoid()
        }
    }
}
