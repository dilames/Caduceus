//
//  NewsPresentingTransition.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/6/18.
//

import UIKit

final class NewsPresentingTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let sourceController: UIViewController & NewsTransitionSourceController
    
    init(sourceController: UIViewController & NewsTransitionSourceController) {
        self.sourceController = sourceController
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let transitionToController = transitionContext.viewController(forKey: .to),
        	let toController = transitionToController as? UIViewController & NewsTransitionDestinationController,
            let collectionView = sourceController.collectionView,
        	let indexPath = sourceController.selectedIndexPath,
        	let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell & NewsTransitionSourceView else {
                return
        }
    
        let containerView = transitionContext.containerView
        sourceController.view.clipsToBounds = true
        toController.view.clipsToBounds = true
        containerView.addSubview(sourceController.view)
        containerView.addSubview(toController.view)
        cell.isHidden = true
        
        prepare(toController, toTransitionFrom: cell)
        let duration = transitionDuration(using: transitionContext)
        toController.animateToPresentingFinishState(with: duration, layouting: true)
        let shadowImageView = dropShadow(onViewOf: toController, insertingInto: containerView)
        
        animate(with: duration, animations: {
            toController.view.frame = toController.resultViewFrame
            toController.view.layer.cornerRadius = 0.0
            self.hideNavigationAndTabBar(of: toController)
            containerView.layoutIfNeeded()
        }, completion: { finished in
            guard finished else { return }
            cell.isHidden = false
            shadowImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
    private func prepare(_ toController: UIViewController & NewsTransitionDestinationController,
                         toTransitionFrom cell: UICollectionViewCell & NewsTransitionSourceView)
    {
        let cellOrigin = cell.convert(CGPoint.zero, to: nil)
        toController.view.frame = CGRect(x: cellOrigin.x, y: cellOrigin.y, width: cell.bounds.width, height: cell.bounds.height)
        toController.view.layer.cornerRadius = cell.viewCornerRadius
        toController.prepareForTransition(previewHeight: cell.bounds.height)
    }
    
    @discardableResult
    private func dropShadow(onViewOf toController: UIViewController, insertingInto containerView: UIView) -> UIView {
        let shadowImageView = UIImageView(image: #imageLiteral(resourceName: "news-item-shadow"))
        shadowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.insertSubview(shadowImageView, belowSubview: toController.view)
        let insets = UIEdgeInsets(top: 18, left: 13, bottom: 13, right: 13)
        shadowImageView.constrain(to: toController.view, insets: insets)
        containerView.layoutSubviews()
        return shadowImageView
    }
    
    private func hideNavigationAndTabBar(of toController: UIViewController) {
        let tabBar = toController.tabBarController?.tabBar
        let tabBarFrame = tabBar?.frame ?? .zero
        tabBar?.frame.origin = CGPoint(x: tabBarFrame.origin.x, y: tabBarFrame.origin.y + tabBarFrame.height)
        
        let navigationBar = toController.navigationController?.navigationBar
        let navigationBarFrame = navigationBar?.frame ?? .zero
        let topHeight = navigationBarFrame.height
        navigationBar?.frame.origin = CGPoint(x: navigationBarFrame.origin.x, y: navigationBarFrame.origin.y - topHeight)
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
