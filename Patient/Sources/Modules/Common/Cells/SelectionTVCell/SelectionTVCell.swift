//
//  SelectionTVCell.swift
//  Patient
//
//  Created by Andrew Chersky on 5/18/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class SelectionTVCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
}

// MARK: - ReusableViewModelContainer
extension SelectionTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: SettingCellViewModel, lifetime: Lifetime) {
        switch viewModel {
        case .editProfile(let viewModel),
             .mapStyle(let viewModel):
            titleLabel.text = viewModel.title
            subtitleLabel.reactive.text <~ viewModel.subtitle
        }
    }
}
