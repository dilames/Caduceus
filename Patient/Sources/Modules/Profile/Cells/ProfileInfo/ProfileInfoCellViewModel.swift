//
//  ProfileInfoCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import class UIKit.UIImage
import ReactiveSwift
import Result

final class ProfileInfoCellViewModel: ViewModel {
    let icon: UIImage
    let keyTitle: String
    let value: MutableProperty<String>
    
    init(icon: UIImage, key: String, value: String) {
        self.icon = icon
        self.keyTitle = key
        self.value = .init(value)
    }
}
