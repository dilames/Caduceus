//
//  ProfileCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import Foundation
import ReactiveSwift
import Result

final class MainInfoCellViewModel: ViewModel {
    let imageURL: MutableProperty<URL?>
    let name: MutableProperty<String>
    let phone: MutableProperty<String>
    
    init(imageURL: URL?, name: String, phone: String) {
        self.imageURL = .init(imageURL)
        self.name = .init(name)
        self.phone = .init(phone)
    }
}
