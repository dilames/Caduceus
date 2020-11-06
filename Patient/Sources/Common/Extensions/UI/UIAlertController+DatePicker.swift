//
//  UIAlertController+DatePicker.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/8/18.
//

import UIKit

extension UIAlertController {
    typealias DateHandler = (Date?) -> Void
    
    static func datePicker(selected: Date? = nil, min: Date? = nil, max: Date? = nil, date: @escaping DateHandler) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: alert.view.frame.width, height: 260))
        datePicker.datePickerMode = .date
        if let selected = selected {
            datePicker.date = selected
        }
        datePicker.maximumDate = max
        datePicker.minimumDate = min
        alert.view.addSubview(datePicker)
        alert.view.clipsToBounds = true
        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                        constant: 370)
        alert.view.addConstraint(height)
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: { _ in
            date(datePicker.date)
        }))
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: { _ in
            date(nil)
        }))
        
        alert.view.tintColor = .cornflowerBlue
        return alert
    }
}
