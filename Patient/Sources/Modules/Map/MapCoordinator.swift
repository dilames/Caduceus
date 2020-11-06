//
//  MapCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import Domain
import UIKit

final class MapCoordinator: BaseCoordinator {
    
    private let navigationController = SideNavigationController()
    private let useCases: UseCaseProvider
    
    init(useCases: UseCaseProvider) {
        self.useCases = useCases
        super.init(rootController: navigationController)
    }
    
    override func start() {
        let viewModel = MapViewModel(isMyLocationEnabled: true, useCases: useCases)
        let mapController = R.storyboard.map.mapViewController()!
        mapController.viewModel = viewModel
        navigationController.pushViewController(mapController, animated: false)
        navigationController.addMenuItemIfNeeded()
    }
}
