//
//  NewsCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/4/18.
//

import UIKit
import Domain
import ReactiveSwift
import Result

final class NewsCoordinator: BaseCoordinator {
    
    private let navigationController = SideNavigationController()
    private let useCases: UseCaseProvider
    private let transitionHandler: NewsNavigationDelegate? = .init()
    
    init(useCases: UseCaseProvider) {
        self.useCases = useCases
        super.init(rootController: navigationController)
    }
    
    override func start() {
        let handlers = NewsViewModel.Handlers(selectNewsItem: openDetailedNews())
        let viewModel = NewsViewModel(useCases: useCases, handlers: handlers)
        let newsController = R.storyboard.news.newsViewController()!
        newsController.viewModel = viewModel
        newsController.definesPresentationContext = true
        navigationController.pushViewController(newsController, animated: false)
        navigationController.addMenuItemIfNeeded()
    }
}

// MARK: - Controllers
extension NewsCoordinator {
    private var detailedNewsController: DetailedNewsViewController {
        let handlers = DetailedNewsViewModel.Handlers(close: closeDetailedNews())
        let viewModel = DetailedNewsViewModel(handlers: handlers)
        let controller = R.storyboard.news.detailedNewsViewController()!
        controller.viewModel = viewModel
        navigationController.delegate = transitionHandler
        return controller
    }
}

// MARK: - Handlers
extension NewsCoordinator {
    private func openDetailedNews() -> Action<NewsCellViewModel, Void, Never> {
        return Action { [weak self] (_) -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            let controller = strongSelf.detailedNewsController
            strongSelf.navigationController.delegate = strongSelf.transitionHandler
            return strongSelf.navigationController.reactive.pushViewController(controller, animated: true)
        }
    }
    
    private func closeDetailedNews() -> ActionHandler {
        return Action { [weak self] (_) -> SignalProducer<Void, Never> in
            guard let strongSelf = self else { return .empty }
            strongSelf.navigationController.viewControllers.last?.reactive.lifetime.observeEnded {
                strongSelf.navigationController.delegate = nil
            }
            return strongSelf.navigationController.reactive.popViewController(animated: true).mapToVoid()
        }
    }
}
