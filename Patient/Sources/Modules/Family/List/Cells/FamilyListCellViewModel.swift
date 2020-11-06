//
//  FamilyListCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import Foundation

enum FamilyListCellViewModel: EquatableViewModel {
    case member(FamilyMemberCellViewModel)
    case addMember(AddNewFamilyMemberCellViewModel)
    
    static func == (lhs: FamilyListCellViewModel, rhs: FamilyListCellViewModel) -> Bool {
        switch (lhs, rhs) {
        case (.member(let lhsViewModel), .member(let rhsViewModel)):
            return lhsViewModel == rhsViewModel
        case (.addMember(let lhsViewModel), .addMember(let rhsViewModel)):
            return lhsViewModel == rhsViewModel
        default:
            return false
        }
    }
}
