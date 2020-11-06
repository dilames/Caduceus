//
//  Coordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

protocol Coordinator: class, ReactiveExtensionsProvider {
    
    /// Root ViewController of Coordinator
    /// Should be retained until coordinator lives
    var rootController: UIViewController { get }
    
    /// Child coordinators of current Coordinator
    /// Are used for retaining supplemented coordinators
    var childs: [Coordinator] { get set }
    
    /// Starts the lifecycle of Coordinator
    /// Presents its controller, sets the ViewModel, etc.
    func start()
    
    /// Finishes the lifecycle of current coordinator
    /// by dissmissing/popping its rootController and removing itself from
    /// childs of its parent Coordinator
    /// - Parameter animated: defines the 'animated' parameter of controller's disappearance
    func finish(animated: Bool)
}

extension Coordinator {
    
    /// Adds child coordinator to childs array
    func add(_ child: Coordinator) {
        childs.append(child)
    }
    
    /// Removes child coordinator from childs array by pointer
    func remove(_ child: Coordinator) {
        childs = childs.filter { $0 !== child }
    }
}

extension Reactive where Base: Coordinator {
    
    /// Starts current Coordinator lifecycle
    /// - Returns: SignalProducer which immediately sends Void value and completes
    func start() -> SignalProducer<Void, Never> {
        base.start()
        return .executingEmpty
    }

    /// Finishes current Coordinator lifecycle
    /// - Parameter animated: defines the 'animated' parameter of controller's disappearance
    /// - Returns: SignalProducer which immediately sends Void value and completes
    func finish(animated: Bool = true) -> SignalProducer<Void, Never> {
        base.finish(animated: animated)
        return .executingEmpty
    }
    
    /// Binding target that finishes current Coordinator lifecycle
    /// by calling 'base.finish(animated:)'
    /// - Parameter animated: defines the 'animated' parameter of controller's disappearance
    /// - Returns: BindingTarget with Void Value for binding any values to itself
    func finish(animated: Bool = true) -> BindingTarget<Void> {
        return makeBindingTarget { base, _ in
            base.finish(animated: animated)
        }
    }
}
