//
//  UITextView+ClearButton.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/15/18.
//

import UIKit

extension UITextField {
    @IBInspectable
    var clearButton: UIImage? {
        get {
            return nil
        }
        set {
            let clearButton = UIButton(type: .system)
            clearButton.setImage(newValue, for: .normal)
            clearButton.frame = CGRect(x: 0, y: 0, width: 25, height: bounds.height)
            clearButton.contentMode = .scaleAspectFill
            clearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
            rightView = clearButton
            rightViewMode = .whileEditing
        }
    }
    
    @objc private func clearTextField(_ sender: Any) {
        text = ""
        sendActions(for: .allEditingEvents)
    }
}
