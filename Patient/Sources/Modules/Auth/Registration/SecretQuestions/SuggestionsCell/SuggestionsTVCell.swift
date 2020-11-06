//
//  SuggestionsTVCell.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/8/18.
//

import UIKit
import ReactiveSwift

final class SuggestionsTVCell: UITableViewCell, ReusableViewModelContainer {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionImageView: UIImageView!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            backgroundColor = .cornflowerBlue
            titleLabel.textColor = .white
            questionImageView.image = #imageLiteral(resourceName: "question-icon")
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.backgroundColor = .clear
                self.titleLabel.textColor = .cornflowerBlue
                self.questionImageView.image = #imageLiteral(resourceName: "question-tint-icon")
            }, completion: nil)
        }
    }
    
    func didSetViewModel(_ viewModel: SuggestionsCellViewModel, lifetime: Lifetime) {
        titleLabel.reactive.text <~ viewModel.text
    }    
}
