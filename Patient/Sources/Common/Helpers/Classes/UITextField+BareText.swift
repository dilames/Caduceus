//
//  UITextField+BareText.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/5/18.
//

import UIKit
import ReactiveSwift
import Result

extension UITextField {
    var textWithoutMask: String {
        guard
            let format = maskFormat else {
            return text ?? ""
        }
        if let text = text, text.isEmpty {
            return text
        }
        let formattedText = removeMask(with: format, from: text ?? "")
        return formattedText
    }
    
    private func removeMask(with format: String, from text: String) -> String {
        return format
            .enumerated()
            .reduce("", {
                guard let currentCharacter = Array(text)[safe: $1.offset] else { return $0 }
                return $1.element == "*" ? ($0 + String(currentCharacter)) : $0
            })
    }
}

extension Reactive where Base: UITextField {
    func continuousTextValuesSkippingMask() -> Signal<String, Never> {
        return continuousTextValues.map { _ in
            return self.base.textWithoutMask
        }
    }
}
