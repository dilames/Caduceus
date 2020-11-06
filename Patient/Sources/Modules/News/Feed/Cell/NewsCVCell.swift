//
//  NewsCVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/3/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

private enum Const {
    static let layerCornerRadius: CGFloat = 15.0
}

final class NewsCVCell: UICollectionViewCell, ReusableViewModelContainer {
    
    var newsPreviewView: NewsPreviewView = NewsPreviewView.instantiateFromNib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
		setupLayer(with: newsPreviewView.bounds)
    }

    private func setupView() {
        newsPreviewView.frame = contentView.bounds
        newsPreviewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(newsPreviewView)
        let hightlightGesture = UILongPressGestureRecognizer(
            target: self, action: #selector(highlightAction(_:)))
        hightlightGesture.cancelsTouchesInView = false
        hightlightGesture.minimumPressDuration = 0.0
        hightlightGesture.delegate = self
        addGestureRecognizer(hightlightGesture)
    }
    
    private func setupLayer(with frame: CGRect) {
        let roundPath = UIBezierPath(roundedRect: frame,
                                     cornerRadius: Const.layerCornerRadius).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath
        shadowOffset = CGSize(width: 0.0, height: 5)
        shadowColor = .black
        shadowOpacity = 0.3
        shadowRadius = 10
        layer.shouldRasterize = true
        layer.shadowPath = roundPath
        contentView.layer.mask = maskLayer
    }
    
    @objc private func highlightAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            highlight(true)
        case .ended, .failed:
            highlight(false)
        default:
            break
        }
    }
    
    private func highlight(_ decreaseSize: Bool) {
        let scaleFactor: CGFloat = 0.95
        let scale = decreaseSize ? CGAffineTransform(scaleX: scaleFactor, y: scaleFactor) : .identity
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.transform = scale
        }, completion: nil)
    }
    
    func didSetViewModel(_ viewModel: NewsCellViewModel, lifetime: Lifetime) {
		newsPreviewView.titleLabel.reactive.text <~ viewModel.title
    }
}

// MARK: - NewsTransitionSourceView
extension NewsCVCell: NewsTransitionSourceView {
    var viewCornerRadius: CGFloat {
        return Const.layerCornerRadius
    }
}

// MARK: - UIGestureRecognizerDelegate
extension NewsCVCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
