//
//  BaseButton.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/28/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class IndicatedButton: UIButton {
    
    var activityStyle: SpinnerViewStyle = .white {
        didSet {
            activity.style = activityStyle
        }
    }
    
    private lazy var activity: SpinnerView = setupActivity()
    private lazy var titleText: String = titleLabel?.text ?? ""
    
    private func setupActivity() -> SpinnerView {
        let activity = SpinnerView(radius: bounds.height / 5, style: activityStyle)
        activity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activity)
        NSLayoutConstraint.activate([activity.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     activity.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     activity.heightAnchor.constraint(equalToConstant: bounds.height),
                                     activity.widthAnchor.constraint(equalToConstant: bounds.height)])
        activity.isHidden = true
        return activity
    }
    
    func startIndicating() {
        setTitle("", for: .normal)
        activity.startAnimating()
        activity.isHidden = false
    }
    
    func stopIndicating() {
        setTitle(titleText, for: .normal)
        titleLabel?.isHidden = false
        activity.stopAnimating()
        activity.isHidden = true
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        if let title = title, !title.isEmpty {
            titleText = title
        }
    }
}

extension Reactive where Base: IndicatedButton {
    var activity: BindingTarget<Bool> {
        return makeBindingTarget {
            $1 ? $0.startIndicating() : $0.stopIndicating()
        }
    }
}
