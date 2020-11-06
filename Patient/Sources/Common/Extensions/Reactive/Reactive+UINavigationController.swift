//
//  Reactive+UINavigationController.swift
//  Order
//
//  Created by Ihor Teltov on 9/29/17.
//  Copyright © 2017 Ihor Teltov. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import Result

public extension Reactive where Base: UINavigationController {
    
    private func transactionProducer<T>(_ transaction: @escaping () -> T) -> SignalProducer<T, Never> {
        return SignalProducer { observer, _ in
            var value: T!
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                observer.send(value: value)
                observer.sendCompleted()
            })
            value = transaction()
            CATransaction.commit()
        }
    }
    
    func push(animated: Bool = true, _ controller: @escaping () -> UIViewController) -> SignalProducer<Void, Never> {
        return transactionProducer { [weak base] in
            base?.pushViewController(controller(), animated: animated)
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) -> SignalProducer<Void, Never> {
        return transactionProducer { [weak base] in
            base?.pushViewController(viewController, animated: animated)
        }
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = true) -> SignalProducer<Void, Never> {
        return transactionProducer { [weak base] in
            base?.setViewControllers(viewControllers, animated: animated)
        }
    }
    
    func popViewController(animated: Bool = true) -> SignalProducer<UIViewController?, Never> {
        return transactionProducer { [weak base] in
            base?.popViewController(animated: animated)
        }
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool = true) -> SignalProducer<Void, Never> {
        return transactionProducer { [weak base] in
            base?.popToViewController(viewController, animated: animated)
        }
    }
    
    func popToRootViewController(animated: Bool = true) -> SignalProducer<Void, Never> {
        return transactionProducer { [weak base] in
            base?.popToRootViewController(animated: animated)
        }
    }
}
