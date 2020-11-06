//
//  BaseNavigationViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
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
    
    private func setupAppearance() {
        navigationBar.tintColor = .cornflowerBlue
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkSlateBlue]
        delegate = self
    }
    
    fileprivate func swapBackItem(for viewController: UIViewController) {
        let backItem = UIBarButtonItem(title: R.string.localizable.back(),
                                       style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = backItem
    }
}

// MARK: - UINavigationControllerDelegate
extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        swapBackItem(for: viewController)
    }
}
