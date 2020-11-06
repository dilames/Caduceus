//
//  FamilyMemberCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import Foundation
import ReactiveSwift
import Result

final class FamilyMemberCellViewModel: EquatableViewModel {
    
    let photoURL: MutableProperty<URL?>
    let name: MutableProperty<String>
    
    init(photoURL: URL?, name: String) {
        self.photoURL = .init(photoURL)
        self.name = .init(name)
    }
    
    static func == (lhs: FamilyMemberCellViewModel, rhs: FamilyMemberCellViewModel) -> Bool {
        return lhs === rhs
    }
}
