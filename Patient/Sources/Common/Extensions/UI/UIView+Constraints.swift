//
//  UIView+Constraints.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/7/18.
//

import UIKit

extension UIView {
    typealias Constraints = (
        top: NSLayoutConstraint, left: NSLayoutConstraint,
        bottom: NSLayoutConstraint, right: NSLayoutConstraint
    )
    
    @discardableResult
    func constrainToSuperview(insetedBy insets: UIEdgeInsets = .zero) -> Constraints {
        guard let superview = superview else { fatalError("No superview") }
        let leading = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: -insets.left)
        let trailing = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right)
        let top = topAnchor.constraint(equalTo: superview.topAnchor, constant: -insets.top)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        return (top, leading, bottom, trailing)
    }
    
    @discardableResult
    func constrain(to view: UIView, insets: UIEdgeInsets = .zero) -> Constraints {
        let leading = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -insets.left)
        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right)
        let top = topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        return (top, leading, bottom, trailing)
    }
    
    @discardableResult
    func constrainToSuperview(insetedBy value: CGFloat) -> Constraints {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        return constrainToSuperview(insetedBy: insets)
    }
    
    @discardableResult
    func constrain(to view: UIView, insetedBy value: CGFloat) -> Constraints {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        return constrain(to: view, insets: insets)
    }
    
    func constrain(toViewFromBelow view: UIView,
                   bottomInset: CGFloat = 0.0,
                   leftInset: CGFloat = 0.0,
                   rightInset: CGFloat = 0.0,
                   height: CGFloat? = nil) {
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomInset),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)]
        )
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
