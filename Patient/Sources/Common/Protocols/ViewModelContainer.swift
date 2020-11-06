//
//  ViewModelContainer.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

public protocol AnyViewModelContainer: class {
    var anyViewModel: Any { get set }
}

// MARK: - ViewModelContainer
public protocol ViewModelContainer: AnyViewModelContainer {
    associatedtype ViewModel
    
    var viewModel: ViewModel { get set }
    func didSetViewModel(_ viewModel: ViewModel, lifetime: Lifetime)
}

public extension ViewModelContainer {
    public var anyViewModel: Any {
        get {
        	return viewModel
        }
        set {
            if let newValue = newValue as? ViewModel {
                viewModel = newValue
            } else {
                fatalError("\(newValue) is not type of \(ViewModel.self)")
            }
        }
        
    }
}

public extension ViewModelContainer where Self: NSObject {
    
    fileprivate var didLoadTrigger: SignalProducer<(), Never> {
        return self is UIViewController ?
            reactive
                .trigger(for: #selector(UIViewController.viewDidLoad))
                .take(first: 1)
                .observe(on: UIScheduler())
                .producer
            : .init(value: ())
    }
    
    public var viewModel: ViewModel {
        get {
            return getAssociatedObject(key: &ViewModelContainerKeys.viewModel)!
        }
        set {
            let viewModel: ViewModel? = getAssociatedObject(key: &ViewModelContainerKeys.viewModel)
            assert(viewModel == nil, "\(type(of: self)) doesn't support reusable viewModel. Use ReusableViewModelContainer instead.")
            
            let token = Lifetime.Token()
            setAssociatedObject(value: token, key: &ViewModelContainerKeys.lifetimeToken, policy: .retain)
            setAssociatedObject(value: newValue, key: &ViewModelContainerKeys.viewModel, policy: .retain)
            
            reactive.makeBindingTarget { $1; $0.didSetViewModel(newValue, lifetime: Lifetime(token)) } <~ didLoadTrigger
        }
    }
}

private enum ViewModelContainerKeys {
    static var viewModel = "viewModel"
    static var lifetimeToken = "lifetimeToken"
}
