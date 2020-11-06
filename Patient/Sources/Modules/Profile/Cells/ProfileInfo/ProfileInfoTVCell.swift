//
//  ProfileInfoTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ProfileInfoTVCell: UITableViewCell {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
}

// MARK: - ReusableViewModelContainer
extension ProfileInfoTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: ProfileCellViewModel, lifetime: Lifetime) {
        switch viewModel {
        case .gender(let viewModel), .birthDate(let viewModel), .email(let viewModel):
            iconImageView.image = viewModel.icon
            keyLabel.text = viewModel.keyTitle
            valueLabel.reactive.text <~ viewModel.value
        default:
            break
        }
    }
}
