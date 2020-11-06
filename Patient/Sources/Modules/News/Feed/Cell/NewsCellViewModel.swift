//
//  NewsCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/3/18.
//

import Foundation
import ReactiveSwift
import Result

final class NewsCellViewModel: ViewModel, Equatable {
    
    let title: MutableProperty<String>
    
    init(title: String) {
        self.title = .init(title)
    }
    
    public static func==(lhs: NewsCellViewModel, rhs: NewsCellViewModel) -> Bool {
        return lhs.title.value == rhs.title.value
    }
}
