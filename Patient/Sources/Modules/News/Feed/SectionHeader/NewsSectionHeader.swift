//
//  NewsSectionHeader.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/5/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class NewsSectionHeader: UICollectionReusableView, ReusableViewModelContainer {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weekDayLabel: UILabel!
    
    func didSetViewModel(_ viewModel: NewsSectionViewModel, lifetime: Lifetime) {
        dateLabel.reactive.text <~ viewModel.dateString
        weekDayLabel.reactive.text <~ viewModel.weekdayString
    }
}
