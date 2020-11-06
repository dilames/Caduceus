//
//  TabBarController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/19/18.
//

import UIKit

protocol TabBarControllerDelegate: class {
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAt index: Int)
}

final class TabBarController: UITabBarController {

    weak var selectionDelegate: TabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        selectionDelegate?.tabBarController(self, didSelectTabAt: selectedIndex)
    }
}

// MARK: - UITabBarDelegate
extension TabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard
            let index = tabBar.items?.index(of: item),
            let selectedView = tabBar.subviews[safe: index + 1] else {
                return
        }
        selectedView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let options: UIViewAnimationOptions = [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: options, animations: {
            selectedView.transform = .identity
        }, completion: nil)
    }
}
