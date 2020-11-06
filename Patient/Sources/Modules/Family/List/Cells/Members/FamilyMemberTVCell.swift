//
//  FamilyMemberTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class FamilyMemberTVCell: UITableViewCell {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userContentView: UIView!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            userContentView.backgroundColor = Constant.selectedColor
        } else {
            UIView.animate(withDuration: Constant.selectedAnimationDuration, animations: {
                self.userContentView.backgroundColor = .white
            })
        }
    }
}

// MARK: - ReusableViewModelContainer
extension FamilyMemberTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: FamilyListCellViewModel, lifetime: Lifetime) {
        guard case .member(let viewModel) = viewModel else { return }
        nameLabel.reactive.text <~ viewModel.name
        photoImageView.reactive.image(animatedWith: .crossDissolve(0.2),
                                      placeholder: #imageLiteral(resourceName: "user-icon")) <~ viewModel.photoURL
    }
}

private enum Constant {
    static let selectedColor: UIColor = UIColor(white: 200.0/255.0, alpha: 1.0)
    static let selectedAnimationDuration: TimeInterval = 0.5
}
