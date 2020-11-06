//
//  ProfileCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import Foundation

enum ProfileCellViewModel: EquatableViewModel {
    case mainInfo(MainInfoCellViewModel)
 	case email(ProfileInfoCellViewModel)
    case gender(ProfileInfoCellViewModel)
    case birthDate(ProfileInfoCellViewModel)
    
    public static func==(lhs: ProfileCellViewModel, rhs: ProfileCellViewModel) -> Bool {
        return false
    }
}
