//
//  DetailedNewsViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/5/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class DetailedNewsViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var previewHolderView: UIView!
    @IBOutlet private weak var articleTopicLabel: UILabel!
    @IBOutlet private weak var articleTextLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private var previewHolderHeight: NSLayoutConstraint!
    @IBOutlet private var previewHolderEqualHeight: NSLayoutConstraint!
    @IBOutlet private var scrollViewTop: NSLayoutConstraint!
    
    // MARK: - Variables
    
    private var previewView: NewsPreviewView = .instantiateFromNib()
    private var markNewsView: MarkNewsView = .instantiateFromNib()
    private var sourcePresentingController: (UIViewController & NewsTransitionSourceController)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setupController()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let markNewsBottomPosition = markNewsView.frame.origin.y + markNewsView.bounds.height
        let bottomInset = markNewsView.bounds.height + (view.bounds.height - markNewsBottomPosition)
        scrollView.contentInset.bottom = bottomInset
        scrollView.scrollIndicatorInsets.top = previewView.bounds.height
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Setup
    
    private func setupController() {
        scrollView.delegate = self
    }
    
    private func setupSubviews() {
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewView.frame = previewHolderView.bounds
        previewHolderView.addSubview(previewView)
        scrollViewTop.constant = -(navigationController?.navigationBar.bounds.height ?? 0)
        view.layoutIfNeeded()
    }
    
    private func addMarkNewsView() {
        let sidePadding: CGFloat = 12
        let height: CGFloat = 68
        let width = view.bounds.width - sidePadding * 2
        let bottom: CGFloat = 26
        let top = view.bounds.height - height - bottom
        let translation = height + bottom
        markNewsView.frame = CGRect(x: sidePadding, y: top + translation,
                                    width: width, height: height)
        markNewsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(markNewsView)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            let origin = self.markNewsView.frame.origin
            self.markNewsView.frame.origin = CGPoint(x: origin.x, y: origin.y - translation)
            self.view.setNeedsLayout()
        }, completion: nil)
        view.layoutIfNeeded()
    }
}

// MARK: - NewsTransitionDestinationController
extension DetailedNewsViewController: NewsTransitionDestinationController {
    func prepareForTransition(previewHeight: CGFloat) {
        previewHolderHeight.constant = previewHeight
        view.layoutIfNeeded()
    }
    
    func animateToPresentingFinishState(with duration: TimeInterval, layouting: Bool) {
        previewHolderHeight.isActive = false
        previewHolderEqualHeight.isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.addMarkNewsView()
        }
        UIView.animate(withDuration: duration / 2) {
            self.previewView.moreButtonBlurView.alpha = 0.0
        }
        if layouting {
            UIView.animate(withDuration: duration) {
                self.view.setNeedsLayout()
            }
        }
    }
    
    func animateToDismissingFinishState(
        with duration: TimeInterval,
        previewHeight: CGFloat,
        previewCornerRadius: CGFloat,
        layouting: Bool)
    {
        view.backgroundColor = nil
        previewHolderEqualHeight.isActive = false
        previewHolderHeight.isActive = true
        previewHolderHeight.constant = previewHeight
        scrollViewTop.constant = 0.0
        previewView.clipsToBounds = true
        closeButton.isHidden = true
        markNewsView.removeFromSuperview()
        UIView.animate(withDuration: duration) {
            self.previewView.layer.cornerRadius = previewCornerRadius
        }
        UIView.animate(withDuration: duration / 2) {
            self.scrollView.setContentOffset(.zero, animated: false)
            self.previewView.moreButtonBlurView.alpha = 1.0
        }
        if layouting {
            UIView.animate(withDuration: duration) {
                self.view.setNeedsLayout()
            }
        }
    }
    
    var resultViewFrame: CGRect {
        return UIScreen.main.bounds
    }
}

// MARK: - ViewModelContainer
extension DetailedNewsViewController: ViewModelContainer {
    func didSetViewModel(_ viewModel: DetailedNewsViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        closeButton.reactive.pressed = CocoaAction(output.close)
    }
}

// MARK: - UIScrollViewDelegate
extension DetailedNewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + 44
        updateCloseButtonStyle(with: offset)
        guard offset <= 0 else { return }
        previewView.transform = CGAffineTransform(translationX: 0.0, y: offset)
    }
    
    private func updateCloseButtonStyle(with offset: CGFloat) {
        let whiteImage = #imageLiteral(resourceName: "close-round-icon-white")
        let blackImage = #imageLiteral(resourceName: "close-round-icon-black")
        var imageToSet: UIImage? = nil
        switch offset {
        case ..<(previewView.bounds.height - (closeButton.bounds.height / 2)):
            if let image = closeButton.imageView?.image, image != whiteImage {
                imageToSet = whiteImage
            }
        default:
            if let image = closeButton.imageView?.image, image != blackImage {
                imageToSet = blackImage
            }
        }
        if let imageToSet = imageToSet, let imageView = closeButton.imageView {
            UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.closeButton.setImage(imageToSet, for: .normal)
            }, completion: nil)
        }
    }
}
