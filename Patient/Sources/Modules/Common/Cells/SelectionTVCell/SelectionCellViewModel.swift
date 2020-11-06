//
//  SelectionCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky on 5/18/18.
//

import Foundation
import ReactiveSwift
import Result

final class SelectionCellViewModel: EquatableViewModel {
    
    var title: String
    var subtitle: MutableProperty<String>
    
    init(title: String, subtitle: String = "") {
        self.title = title
        self.subtitle = .init(subtitle)
    }
    
    static func==(lhs: SelectionCellViewModel, rhs: SelectionCellViewModel) -> Bool {
        return false
    }
}
