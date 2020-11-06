//
//  SearchUserTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 6/1/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class SearchUserTVCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var yearsLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - ReusableViewModelContainer
extension SearchUserTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: SearchUserCellViewModel, lifetime: Lifetime) {
        iconImageView.reactive.image(animatedWith: .crossDissolve(0.3),
                                     placeholder: #imageLiteral(resourceName: "user-icon")) <~ viewModel.photoURL
        nameLabel.reactive.text <~ viewModel.fullName
        yearsLabel.reactive.text <~ viewModel.years
        phoneLabel.reactive.text <~ viewModel.phone
        infoButton.reactive.pressed = CocoaAction(viewModel.infoAction)
    }
}
