//
//  SwitchCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky on 5/18/18.
//

import Foundation
import ReactiveSwift
import Result

final class SwitchCellViewModel: EquatableViewModel {
    
    var isOn: MutableProperty<Bool>
    var title: String
    
    init(isOn: Bool, title: String) {
        self.isOn = .init(isOn)
        self.title = title
    }
    
    static func==(lhs: SwitchCellViewModel, rhs: SwitchCellViewModel) -> Bool {
        return false
    }
}
