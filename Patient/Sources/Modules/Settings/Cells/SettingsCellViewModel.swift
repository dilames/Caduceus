//
//  SettingCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky on 5/18/18.
//

import Foundation

enum SettingCellViewModel: EquatableViewModel {
    
    case editProfile(SelectionCellViewModel)
    case mapStyle(SelectionCellViewModel)
    
    static func == (lhs: SettingCellViewModel, rhs: SettingCellViewModel) -> Bool {
        switch (lhs, rhs) {
        case (.editProfile(let leftModel), .editProfile(let rightModel)):
            return leftModel == rightModel
        case (.mapStyle(let leftModel), .mapStyle(let rightModel)):
            return leftModel == rightModel
        default:
            return false
        }
    }
    
}
