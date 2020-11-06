//
//  View+NibLoadable.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/13/18.
//

import UIKit

protocol NibLoadable {}
extension UIView: NibLoadable {}
extension UIViewController: NibLoadable {}

extension NibLoadable where Self: UIView {
    static func instantiateFromNib() -> Self {
        let nibName = "\(Self.self)"
        if let nib = UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as? Self {
            return nib
        } else {
            fatalError("Unable to instantiate nib: \(nibName)")
        }
    }
}

extension NibLoadable where Self: UIViewController {
    static func instantiateFromNib() -> Self {
        let nibName = "\(Self.self)"
        return Self(nibName: nibName, bundle: nil)
    }
}
