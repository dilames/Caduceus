//
//  Reactive+View.swift
//  Patient
//
//  Created by Andrew Chersky  on 6/2/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UIView {
    func hide(animated: Bool, duration: TimeInterval = 0.3) -> BindingTarget<Bool> {
        return makeBindingTarget { view, flag in
            UIView.animate(withDuration: animated ? duration : 0.0, animations: {
                view.alpha = flag ? 0.0 : 1.0
            })
        }
    }
}
