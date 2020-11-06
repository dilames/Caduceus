//
//  ChooseMapStyleTVCell.swift
//  Patient
//
//  Created by Andrew Chersky on 5/30/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class ChooseMapStyleTVCell: UITableViewCell {
    @IBOutlet private weak var styleTitle: UILabel!
    @IBOutlet private weak var styleColorView: UIView!
}

// MARK: - ReusableViewModelContainer
extension ChooseMapStyleTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: ChooseMapStyleCellViewModel, lifetime: Lifetime) {
        self.styleTitle.text = viewModel.title
        self.styleColorView.backgroundColor = viewModel.color
    }
}
