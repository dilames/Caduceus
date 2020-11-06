//
//  SideMenuProfileCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import UIKit.UIImage
import ReactiveSwift
import Result

final class SideMenuProfileCellViewModel: EquatableViewModel {
    let username: MutableProperty<String>
    let userImageUrl: MutableProperty<URL?>
    
    init(username: String, userImageUrl: URL?) {
        self.username = .init(username)
        self.userImageUrl = .init(userImageUrl)
    }
    
    static func==(lhs: SideMenuProfileCellViewModel, rhs: SideMenuProfileCellViewModel) -> Bool {
        return false
    }
}
