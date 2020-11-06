//
//  SideNavigationController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import UIKit
import ReactiveSwift
import Result

final class SideNavigationController: BaseNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
		addMenuItem()
    }
    
    private func addMenuItem() {
        let menuItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user-icon"), style: .done, target: self,
                                 action: #selector(menuItemAction(_:)))
        viewControllers.first?.navigationItem.leftBarButtonItem = menuItem
    }
    
    func addMenuItemIfNeeded() {
        if viewControllers.first?.navigationItem.leftBarButtonItem == nil {
            addMenuItem()
        }
    }
    
    @objc fileprivate func menuItemAction(_ sender: Any) {}
}

extension Reactive where Base: SideNavigationController {
    var menuItemSelection: SignalTrigger {
        return base.reactive.trigger(for: #selector(Base.menuItemAction(_:)))
    }
}
