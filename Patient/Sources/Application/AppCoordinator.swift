//
//  AppCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/19/18.
//

import UIKit
import Domain
import ReactiveSwift
import Result
import UIWindowTransitions

final class AppCoordinator {
    
    enum Flow {
        case auth
        case main
    }
    
    let window: UIWindow
    let useCases: UseCaseProvider
    
    private var coordinator: Any?
    private var flow: Flow? {
        didSet {
            if flow != oldValue {
                flowDidUpdate()
            }
        }
    }
    
    init(window: UIWindow = UIWindow(frame: UIScreen.main.bounds), useCases: UseCaseProvider) {
        self.window = window
        self.useCases = useCases
        setupFlow()
        window.makeKeyAndVisible()
    }
    
    /// Setups flow after app start
    private func setupFlow() {
        flow = .auth
//        flow = useCases.session.isSessionAlive ? .main : .auth
    }
    
    private func flowDidUpdate() {
        guard let flow = flow else { return }
        switch flow {
        case .auth:
            let authCoordinator = AuthCoordinator(useCases: useCases, openMainFlow: openMainFlow())
            authCoordinator.start()
            coordinator = authCoordinator
            
            if window.rootViewController == nil {
                window.rootViewController = authCoordinator.rootController
            } else {
                window.setRootViewController(authCoordinator.rootController,
                                             options: windowTransitionsOptions)
            }
            
        case .main:
            let tabBarCoordinator = TabBarCoordinator(useCases: useCases)
            tabBarCoordinator.start()
            coordinator = tabBarCoordinator
            
            if let presentedNavigation = window.rootViewController?.presentedViewController as? UINavigationController {
                window.rootViewController?.dismiss(animated: true, completion: {
                presentedNavigation.setViewControllers([], animated: false)
                    self.window.setRootViewController(tabBarCoordinator.rootController,
                                                 options: self.windowTransitionsOptions)
                })
            } else {
                window.setRootViewController(tabBarCoordinator.rootController,
                                             options: windowTransitionsOptions)
            }
        }
    }
    
    private func openMainFlow() -> ActionHandler {
        return Action { [weak self] (_) -> ProducerTrigger in
            return SignalProducer { observer, _ in
                self?.flow = .main
                observer.send(value: ())
                observer.sendCompleted()
            }
        }
    }
    
    private var windowTransitionsOptions: UIWindow.TransitionOptions {
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        options.duration = 0.5
        options.style = .easeOut
        return options
    }
}
