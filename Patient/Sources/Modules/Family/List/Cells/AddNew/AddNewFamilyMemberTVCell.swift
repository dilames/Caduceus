//
//  AddNewFamilyMemberTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class AddNewFamilyMemberTVCell: UITableViewCell {

    @IBOutlet private weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - ReusableViewModelContainer
extension AddNewFamilyMemberTVCell: ReusableViewModelContainer {
    func didSetViewModel(_ viewModel: FamilyListCellViewModel, lifetime: Lifetime) {
        guard case .addMember(let viewModel) = viewModel else { return }
        button.reactive.pressed = CocoaAction(viewModel.buttonAction)
    }
}
