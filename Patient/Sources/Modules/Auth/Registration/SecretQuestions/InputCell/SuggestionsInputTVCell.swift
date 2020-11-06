//
//  SuggestionsInputTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/8/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class SuggestionsInputTVCell: UITableViewCell, ReusableViewModelContainer {

    @IBOutlet weak var textHolderView: DesignableView!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textHolderView.layer.cornerRadius = 25.0
    }

    func didSetViewModel(_ viewModel: SuggestionsInputCellViewModel, lifetime: Lifetime) {
        textField.reactive.text <~ viewModel.text.skipRepeats()
        viewModel.text <~ textField.reactive.continuousTextValues
    }
}
