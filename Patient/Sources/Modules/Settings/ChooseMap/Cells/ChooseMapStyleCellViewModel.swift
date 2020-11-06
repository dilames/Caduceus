//
//  ChooseMapStyleCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky on 5/30/18.
//

import Foundation
import class UIKit.UIColor

final class ChooseMapStyleCellViewModel: EquatableViewModel {
    
    var color: UIColor
    var title: String
    
    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
    
    static func == (lhs: ChooseMapStyleCellViewModel, rhs: ChooseMapStyleCellViewModel) -> Bool {
        return false
    }
}
