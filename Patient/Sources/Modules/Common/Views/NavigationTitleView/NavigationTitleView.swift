//
//  NavigationTitleView.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/13/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class NavigationTitleView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var spinnerView: SpinnerView!
    @IBOutlet private weak var titleLeading: NSLayoutConstraint!
    @IBOutlet private weak var titleTrailing: NSLayoutConstraint!
    
    var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinnerView.radius = bounds.height / 2
    }
    
    private func setup() {
        spinnerView.alpha = 0.0
        spinnerView.style = .tint
    }
    
    func startAnimating() {
        spinnerView.startAnimating()
        titleTrailing.constant = 4.0
        UIView.animate(withDuration: 0.2) {
            self.spinnerView.alpha = 1.0
            self.layoutIfNeeded()
        }
    }
    
    func stopAnimating() {
        titleTrailing.constant = -spinnerView.bounds.width
        UIView.animate(withDuration: 0.2, animations: {
            self.spinnerView.alpha = 0.0
            self.layoutIfNeeded()
        }, completion: { _ in
        	self.spinnerView.stopAnimating()
        })
    }
}

extension Reactive where Base: NavigationTitleView {
    var activity: BindingTarget<Bool> {
        return makeBindingTarget {
            $1 ? $0.startAnimating() : $0.stopAnimating()
        }
    }
}
