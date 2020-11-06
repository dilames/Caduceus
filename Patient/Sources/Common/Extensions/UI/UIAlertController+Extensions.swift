//
//  UIAlertController+Extensions.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Domain
import UIKit

extension UIAlertController {
    static func error(_ error: Error) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .actionSheet)
        return alert
    }
    
    static func confirmPhoneType(handler: @escaping (PhoneConfirmationType?) -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: R.string.localizable.chooseConfirmationType(),
            message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .cornflowerBlue
        alert.addAction(.init(title: R.string.localizable.confirmationMessage(), style: .default, handler: { _ in
            handler(.message)
        }))
        alert.addAction(.init(title: R.string.localizable.confirmationCall(), style: .default, handler: { _ in
            handler(.call)
        }))
        alert.addAction(.init(title: R.string.localizable.cancel(), style: .cancel, handler: { _ in
            handler(nil)
        }))
        return alert
    }
}
