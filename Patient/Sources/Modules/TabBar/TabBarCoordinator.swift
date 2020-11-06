//
//  TabBarCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/19/18.
//

import UIKit
import Domain
import SideMenu

final class TabBarCoordinator: BaseCoordinator {

	typealias UseCases = UseCaseProvider
    
    private let tabBarController: TabBarController
    private let useCases: UseCases
    
    private var sideMenuCoordinator: SideMenuCoordinator? {
        return childs
            .filter {$0 is SideMenuCoordinator}
        	.first as? SideMenuCoordinator
    }
    
    init(useCases: UseCaseProvider) {
        self.useCases = useCases
        tabBarController = R.storyboard.main.tabBarController()!
        super.init(rootController: tabBarController)
    }
    
    override func start() {
        addNewsTab()
        addMapTab()
        tabBarController.setViewControllers(childs.map { $0.rootController }, animated: false)
        tabBarController.selectionDelegate = self
        addMenuCoordinator()
    }
    
    private func addNewsTab() {
        addTab(coordinator: NewsCoordinator(useCases: useCases),
               tabBarItem: UITabBarItem(title: R.string.localizable.news(), image: #imageLiteral(resourceName: "news-tab-icon"), selectedImage: #imageLiteral(resourceName: "news-tab-icon-active")))
    }
    
    private func addMapTab() {
        addTab(coordinator: MapCoordinator(useCases: useCases),
               tabBarItem: UITabBarItem(title: R.string.localizable.map(), image: #imageLiteral(resourceName: "map-tab-icon"), selectedImage: #imageLiteral(resourceName: "map-tab-icon-active")))
    }
    
    private func addTab(coordinator: BaseCoordinator, tabBarItem: UITabBarItem) {
        add(coordinator)
        coordinator.start()
        coordinator.rootController.tabBarItem = tabBarItem
    }
    
    private func addMenuCoordinator() {
        let selectedIndex = tabBarController.tabBarController?.tabBarController?.selectedIndex ?? 0
        let childControllers = childs.map {$0.rootController}
        if let sourceNavigationController = childControllers[selectedIndex] as? SideNavigationController {
            let sideMenuCoordinator = SideMenuCoordinator(
                sourceNavigationController: sourceNavigationController,
                useCases: useCases)
            add(sideMenuCoordinator)
            sideMenuCoordinator.start()
        }
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: tabBarController.view)
    }
}

// MARK: - UITabBarDelegate
extension TabBarCoordinator: TabBarControllerDelegate {
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAt index: Int) {
        let childControllers = childs.map {$0.rootController}
        if let sourceNavigationController = childControllers[index] as? SideNavigationController {
            sideMenuCoordinator?.sourceNavigationController = sourceNavigationController
        }
    }
}
