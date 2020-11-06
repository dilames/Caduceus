//
//  SuggestionsCellViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/8/18.
//

import Foundation
import ReactiveSwift
import Result

final class SuggestionsCellViewModel: ViewModel {
    
    let text: MutableProperty<String>
    
    init(text: String) {
        self.text = .init(text)
    }
}
