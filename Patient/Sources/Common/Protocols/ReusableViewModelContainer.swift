//
//  ReusableViewModelContainer.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Foundation
import Extensions
import ReactiveSwift
import ReactiveCocoa
import Result

public protocol AnyReusableViewModelContainer: class {
    var anyViewModel: Any? { get set }
}

public protocol ReusableViewModelContainer: AnyReusableViewModelContainer {
    associatedtype ViewModel
    
    var viewModel: ViewModel? { get set }
    func prepareForReuse()
    
    func didSetViewModel(_ viewModel: ViewModel, lifetime: Lifetime)
}

public extension ReusableViewModelContainer {
    var anyViewModel: Any? {
        get {
        	return viewModel
        }
        set {
            viewModel = newValue as? ViewModel
        }
    	
    }
}

public extension ReusableViewModelContainer where Self: NSObject {
    
    fileprivate var didLoadTrigger: SignalProducer<(), Never> {
        return self is UIViewController ?
            reactive
                .trigger(for: #selector(UIViewController.viewDidLoad))
                .take(first: 1)
                .observe(on: UIScheduler())
                .producer
            : .init(value: ())
    }
    
    public var viewModel: ViewModel? {
        get {
            return getAssociatedObject(key: &ViewModelContainerKeys.viewModel)!
        }
        set {
            removeAssociatedObject(key: &ViewModelContainerKeys.lifetimeToken)
            setAssociatedObject(value: newValue, key: &ViewModelContainerKeys.viewModel, policy: .retain)
            if let newValue = newValue {
                let token = Lifetime.Token()
                setAssociatedObject(value: token, key: &ViewModelContainerKeys.lifetimeToken, policy: .retain)
                reactive.makeBindingTarget { $1; $0.didSetViewModel(newValue, lifetime: Lifetime(token))} <~ didLoadTrigger
            }
        }
    }
}

private enum ViewModelContainerKeys {
    static var viewModel = "viewModel"
    static var lifetimeToken = "lifetimeToken"
}
