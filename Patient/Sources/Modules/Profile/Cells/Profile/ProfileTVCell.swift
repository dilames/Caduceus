//
//  ProfileTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ProfileTVCell: UITableViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
}

// MARK: - ReusableViewModelContainer
extension ProfileTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: ProfileCellViewModel, lifetime: Lifetime) {
        guard case .mainInfo(let viewModel) = viewModel else { return }
        photoImageView.reactive.image(animatedWith: .crossDissolve(0.2),
                                      placeholder: nil) <~ viewModel.imageURL
        nameLabel.reactive.text <~ viewModel.name
        phoneLabel.reactive.text <~ viewModel.phone
    }
}
