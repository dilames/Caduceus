//
//  UITextField+MaskedInput.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/4/18.
//

import UIKit
import Extensions

extension UITextField {
    var maskFormat: String? {
        get {
            return maskedInput?.format
        }
        set {
            if let newValue = newValue {
            	let maskedInput = MaskedInput(format: newValue)
                self.maskedInput = maskedInput
                maskedInput.dataSource = self
                maskedInput.delegate = self
                addTarget(self, action: #selector(applyMaskTransform(_:)), for: .allEditingEvents)
            } else {
                self.maskedInput = nil
                removeTarget(self, action: #selector(applyMaskTransform(_:)), for: .allEditingEvents)
            }
        }
    }
    
    func setMaskType(_ maskType: MaskedInput.MaskType) {
        maskFormat = maskType.format
    }
    
    private var maskedInput: MaskedInput? {
        get {
            let maskedInput: MaskedInput? = getAssociatedObject(key: &MaskConstant.input)
            return maskedInput
        }
        set {
            if let newValue = newValue {
                setAssociatedObject(value: newValue, key: &MaskConstant.input, policy: .retain)
            } else {
                removeAssociatedObject(key: &MaskConstant.input)
            }
        }
    }
    
    @objc private func applyMaskTransform(_ sender: Any?) {
        maskedInput?.applyTransform()
    }
}

extension UITextField: MaskedInputDataSource {
    func maskedInputText(_ maskedInput: MaskedInput) -> String {
        return text ?? ""
    }
}

extension UITextField: MaskedInputDelegate {
    func maskedInput(_ maskedInput: MaskedInput, didTransformInputTo output: String) {
        text = output
    }
}

private enum MaskConstant {
    static var input: String = "text.field.masked.input"
}
