//
//  NewsNavigationDelegate.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/7/18.
//

import UIKit

class NewsNavigationDelegate: NSObject, UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        switch operation {
        case .push:
            if let fromVC = fromVC as? UIViewController & NewsTransitionSourceController {
            	return NewsPresentingTransition(sourceController: fromVC)
            }
        case .pop:
            if let toVC = toVC as? UIViewController & NewsTransitionSourceController {
            	return NewsDismissalTransition(destinationController: toVC)
            }
        default:
            return nil
        }
        return nil
    }
}
