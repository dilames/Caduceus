//
//  AddNewFamilyMemberCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import Foundation

final class AddNewFamilyMemberCellViewModel: EquatableViewModel {
    
    let buttonAction: ActionHandler
    
    init(buttonAction: ActionHandler) {
        self.buttonAction = buttonAction
    }
    
    static func == (lhs: AddNewFamilyMemberCellViewModel, rhs: AddNewFamilyMemberCellViewModel) -> Bool {
        return lhs === rhs
    }
}
