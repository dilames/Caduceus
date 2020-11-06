//
//  SideMenuCommonTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import UIKit
import ReactiveSwift

final class SideMenuCommonTVCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
}

extension SideMenuCommonTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: SideMenuCellViewModel, lifetime: Lifetime) {
        switch viewModel {
        case .settings(let viewModel), .family(let viewModel):
            titleLabel.text = viewModel.text
            iconImageView.image = viewModel.icon
        default:
            break
        }
        
    }
}
