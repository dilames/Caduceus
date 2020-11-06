//
//  Reactive+UIViewController.swift
//  Order
//
//  Created by Ihor Teltov on 9/28/17.
//  Copyright © 2017 Ihor Teltov. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import Result

public extension Reactive where Base: UIViewController {
    
    func show(_ controller: UIViewController, sender: Any? = nil) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak base] observer, _ in
            guard let base = base else { return }
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                observer.send(value: ())
                observer.sendCompleted()
            }
            base.show(controller, sender: sender)
            CATransaction.commit()
        }
    }
    
    func present(_ controller: UIViewController, animated: Bool) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak base] observer, _ in
            guard let base = base else { return }
            base.present(controller, animated: animated, completion: {
                observer.send(value: ())
                observer.sendCompleted()
            })
        }
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)? = nil) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak base] observer, _ in
            guard let base = base else { return }
            base.dismiss(animated: animated, completion: {
                completion?()
                observer.send(value: ())
                observer.sendCompleted()
            })
        }
    }
    
    func dismiss() -> SignalProducer<Void, Never> {
        return self.dismiss(animated: true)
    }
    
}
