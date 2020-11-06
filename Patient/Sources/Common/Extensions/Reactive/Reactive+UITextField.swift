//
//  Reactive+UITextField.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/10/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

extension Reactive where Base: UITextField {
    var becomeFirstResponder: BindingTarget<Void> {
        return makeBindingTarget { textField, _ in
            textField.becomeFirstResponder()
        }
    }
}
