//
//  NewsDismissingTransition.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/6/18.
//

import UIKit

final class NewsDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let destinationController: UIViewController & NewsTransitionSourceController
    
    init(destinationController: UIViewController & NewsTransitionSourceController) {
        self.destinationController = destinationController
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromTransitionController = transitionContext.viewController(forKey: .from),
            let fromController = fromTransitionController as? UIViewController & NewsTransitionDestinationController,
            let collectionView = destinationController.collectionView,
        	let indexPath = destinationController.selectedIndexPath,
        	let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell & NewsTransitionSourceView else {
                return
        }
        
        let toController = destinationController
        let containerView = transitionContext.containerView
        containerView.addSubview(toController.view)
        containerView.addSubview(fromController.view)
        cell.isHidden = true
        
        let cellOrigin = cell.convert(CGPoint.zero, to: nil)
        
        let duration = transitionDuration(using: transitionContext)
        let cellFrame = CGRect(x: cellOrigin.x, y: cellOrigin.y,
                               width: cell.bounds.width, height: cell.bounds.height)
        fromController.animateToDismissingFinishState(
            with: duration,
            previewHeight: cell.bounds.height,
            previewCornerRadius: cell.viewCornerRadius,
            layouting: false)
        containerView.layoutIfNeeded()
        
        let shadowImageView = dropShadow(onViewOf: fromController, insertingInto: containerView)
        hideTabAndNavigationBar(of: toController)
        animate(with: duration, animations: {
            fromController.view.frame = cellFrame
            fromController.view.layer.cornerRadius = cell.viewCornerRadius
            containerView.layoutIfNeeded()
        }, completion: { finished in
            guard finished else { return }
            cell.isHidden = false
            shadowImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
        UIView.animate(withDuration: duration / 2.5) {
            self.restoreTabAndNavigationBar(of: toController)
        }
    }
    
    @discardableResult
    private func dropShadow(onViewOf fromController: UIViewController, insertingInto containerView: UIView) -> UIView {
        let shadowImageView = UIImageView(image: #imageLiteral(resourceName: "news-item-shadow"))
        shadowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.insertSubview(shadowImageView, belowSubview: fromController.view)
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 24, right: 20)
        shadowImageView.constrain(to: fromController.view, insets: insets)
        containerView.layoutSubviews()
        return shadowImageView
    }
    
    private func hideTabAndNavigationBar(of toController: UIViewController) {
        let tabBar = toController.tabBarController?.tabBar
        let tabBarFrame = tabBar?.frame ?? .zero
        tabBar?.frame.origin = CGPoint(x: tabBarFrame.origin.x, y: tabBarFrame.origin.y + tabBarFrame.height)
        
        let navigationBar = toController.navigationController?.navigationBar
        let navigationBarFrame = navigationBar?.frame ?? .zero
        let topHeight = navigationBarFrame.height
        navigationBar?.frame.origin = CGPoint(x: navigationBarFrame.origin.x, y: navigationBarFrame.origin.y - topHeight)
    }
    
    private func restoreTabAndNavigationBar(of toController: UIViewController) {
        let tabBar = toController.tabBarController?.tabBar
        let tabBarFrame = tabBar?.frame ?? .zero
        tabBar?.frame.origin = CGPoint(x: tabBarFrame.origin.x, y: tabBarFrame.origin.y - tabBarFrame.height)
        
        let navigationBar = toController.navigationController?.navigationBar
        let navigationBarFrame = navigationBar?.frame ?? .zero
        let topHeight = navigationBarFrame.height
        navigationBar?.frame.origin = CGPoint(x: navigationBarFrame.origin.x, y: navigationBarFrame.origin.y + topHeight)
        navigationBar?.superview?.layoutIfNeeded()
    }
    
    private func animate(with duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: [],
            animations: animations,
            completion: completion
        )
    }
}
