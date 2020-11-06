//
//  SideMenuCommonCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import Foundation
import UIKit.UIImage

final class SideMenuCommonCellViewModel: EquatableViewModel {
    let text: String
    let icon: UIImage
    
    init(text: String, icon: UIImage) {
        self.text = text
        self.icon = icon
    }
    
    static func==(lhs: SideMenuCommonCellViewModel, rhs: SideMenuCommonCellViewModel) -> Bool {
        return false
    }
}
