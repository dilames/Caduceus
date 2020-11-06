//
//  BaseViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class BaseViewController: UIViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func addViewEndEditingOnTouch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapAction(_ sender: Any) {
    	view.endEditing(true)
    }
}

extension Reactive where Base: BaseViewController {
    var activity: BindingTarget<Bool> {
        return makeBindingTarget { _, _ in
            // add activity later
        }
    }
    
    var errors: BindingTarget<AnyError> {
        return makeBindingTarget {
            let error = $1 as Error
            let alert: UIAlertController = .error(error)
            $0.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    var endEditing: BindingTarget<Void> {
        return makeBindingTarget { controller, _ in
            controller.view.endEditing(true)
        }
    }
}
