//
//  DimmingPresentationController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/7/18.
//

import UIKit

protocol PresentationControllerProtocol {
    var shouldDissmiss: Bool { get }
}

final class DimmingPresentationController: UIPresentationController {
    
    // MARK: - Types
    
    struct Insets {
        let dxLength: CGFloat
        let dyLength: CGFloat
        static var zero: Insets {
            return Insets(dxLength: 0.0, dyLength: 0.0)
        }
    }
    
    struct Options {
        var shouldDimPresentingController: Bool
        var shouldReducePresentingController: Bool
        var cornerRadiusOfPresentingController: CGFloat
        var cornerRadiusOfPresentedController: CGFloat
        var shadowAlpha: CGFloat
        
        static var `default`: Options {
            return Options(
                shouldDimPresentingController: true,
                shouldReducePresentingController: false,
                cornerRadiusOfPresentingController: 0.0,
                cornerRadiusOfPresentedController: 0.0,
                shadowAlpha: 0.3
            )
        }
    }
    
    // MARK: - Variables
    
    public var insets: Insets
    public var offset: Insets
    public var options: Options
    
    fileprivate lazy var dimmingView: UIView = {
        let dimmingView = UIView(frame: UIScreen.main.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(options.shadowAlpha)
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return dimmingView
    }()
    
    fileprivate lazy var wrapperView: UIView = {
        let wrapperView = UIView(frame: UIScreen.main.bounds)
        wrapperView.backgroundColor = .clear
        return wrapperView
    }()
    
    // MARK: - Lifecycle
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        insets = .zero
        offset = .zero
        options = .default
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    public init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        options: Options = .default,
        insets: Insets = .zero,
        offset: Insets = .zero)
    {
        self.options = options
        self.insets = insets
        self.offset = offset
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    // MARK: - Overrides
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        wrapperView.frame = frameOfPresentedViewInContainerView
    }
    
    override var presentedView: UIView? {
        return wrapperView
    }
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        
        dimmingView.backgroundColor = .clear
        containerView?.addSubview(dimmingView)
        
        presentedViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentedViewController.view.frame = wrapperView.bounds
        wrapperView.addSubview(presentedViewController.view)
        
        wrapperView.frame = dimmingView.bounds
        dimmingView.addSubview(wrapperView)
        
        presentingViewController.view.setAndAlignPositionOf(anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                if self.options.shouldDimPresentingController {
                    self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(self.options.shadowAlpha)
                }
                if self.options.cornerRadiusOfPresentedController != 0.0 {
                    self.addRoundMask(to: self.presentedViewController.view)
                }
                if self.options.cornerRadiusOfPresentingController != 0.0 {
                    self.presentingViewController.view.layer.masksToBounds = true
                    self.presentingViewController.view.layer.cornerRadius = self.options.cornerRadiusOfPresentingController
                }
                if self.options.shouldReducePresentingController {
                    self.apply3dTransform(for: self.presentingViewController.view)
                }
        },
            completion: { _ in
        })
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
        
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:))))
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.dimmingView.backgroundColor = .clear
                self.presentingViewController.view.layer.transform = CATransform3DIdentity
                self.presentingViewController.view.layer.cornerRadius = 0.0
        },
            completion: { _ in
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return super.frameOfPresentedViewInContainerView
            .insetBy(
                dx: insets.dxLength,
                dy: insets.dyLength)
            .offsetBy(
                dx: offset.dxLength,
                dy: offset.dyLength)
    }
    
    // MARK: - Private methods
    
    private func addRoundMask(to view: UIView) {
        let maskPath = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: self.options.cornerRadiusOfPresentedController,
                                height: self.options.cornerRadiusOfPresentedController)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
    private func apply3dTransform(for view: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, CGFloat(Double.pi * 0.03), 1.0, 0.0, 0.0)
        transform = CATransform3DTranslate(transform, 0.0, -30.0, 0.0)
        view.layer.transform = transform
    }
    
    // MARK: - Actions
    
    @objc func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        let shouldDismiss = (presentedViewController as? PresentationControllerProtocol)?.shouldDissmiss ?? true
        if shouldDismiss {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
}
