//
//  SideMenuCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import Foundation

enum SideMenuCellViewModel: EquatableViewModel {
    case profile(SideMenuProfileCellViewModel)
    case settings(SideMenuCommonCellViewModel)
    case family(SideMenuCommonCellViewModel)
    
    static func == (lhs: SideMenuCellViewModel, rhs: SideMenuCellViewModel) -> Bool {
        switch (lhs, rhs) {
        case (.profile(let lhsCellViewModel), .profile(let rhsCellViewModel)):
            return lhsCellViewModel == rhsCellViewModel
        case (.settings(let lhsCellViewModel), .settings(let rhsCellViewModel)):
            return lhsCellViewModel == rhsCellViewModel
        case (.family(let lhsCellViewModel), .family(let rhsCellViewModel)):
            return lhsCellViewModel == rhsCellViewModel
        default:
            return false
        }
    }
}
