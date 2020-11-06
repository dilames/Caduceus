//
//  SearchUserCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 6/1/18.
//

import Foundation
import ReactiveSwift
import Result

final class SearchUserCellViewModel: EquatableViewModel {
    
    private let id: String
    
    let photoURL: MutableProperty<URL?>
    let fullName: MutableProperty<String>
    let years: MutableProperty<String>
    let phone: MutableProperty<String>
    let infoAction: ActionHandler
    
    init(id: String,
         photoURL: URL?,
         fullName: String,
         birthDate: Date,
         phone: String,
         infoAction: ActionHandler) {
        self.id = id
        self.photoURL = .init(photoURL)
        self.fullName = .init(fullName)
        let years = Calendar.current.dateComponents([.year], from: birthDate).year ?? 0
        self.years = .init(String(describing: years) + " years old")
        self.phone = .init(phone)
        self.infoAction = infoAction
    }
    
    public static func==(lhs: SearchUserCellViewModel, rhs: SearchUserCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
