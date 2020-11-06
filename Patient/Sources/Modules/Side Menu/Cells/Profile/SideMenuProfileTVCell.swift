//
//  SideMenuProfileTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class SideMenuProfileTVCell: UITableViewCell {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var profileView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        removeOuterSeparators()
    }
    
    private func setupView() {
        selectionStyle = .none
        let hightlightGesture = UILongPressGestureRecognizer(
            target: self, action: #selector(highlightAction(_:)))
        hightlightGesture.cancelsTouchesInView = false
        hightlightGesture.minimumPressDuration = 0.0
        hightlightGesture.delegate = self
        profileView.addGestureRecognizer(hightlightGesture)
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
        let options: UIViewAnimationOptions = [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]
        UIView.animate(withDuration: 0.3, delay: 0.0, options: options, animations: {
            self.profileView.transform = scale
        }, completion: nil)
    }
    
    private func removeOuterSeparators() {
        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }
}

// MARK: - ReusableViewModelContainer
extension SideMenuProfileTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: SideMenuCellViewModel, lifetime: Lifetime) {
        if case .profile(let viewModel) = viewModel {
            usernameLabel.reactive.text <~ viewModel.username
            profileImageView.reactive.image(
                animatedWith: .crossDissolve(0.3),
                placeholder: #imageLiteral(resourceName: "menu-icon-profile")) <~ viewModel.userImageUrl
        }        
    }
}
