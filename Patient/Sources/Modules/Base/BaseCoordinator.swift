//
//  BaseCoordinator.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/11/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class BaseCoordinator: NSObject, Coordinator {
    
    /// Root level controller from whole flow.
    let rootController: UIViewController
    var childs: [Coordinator] = []
    private let finishPipe = Signal<Bool, Never>.pipe()
    
    init(rootController: UIViewController) {
        self.rootController = rootController
        super.init()
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func start() {
        assertionFailure("Should be overridden in subclass: \(type(of: self))")
    }

    func add(_ child: Coordinator) {
        childs.append(child)
        guard let child = child as? BaseCoordinator else { return }
        child.finishPipe.output.observeValues { animated in
            if let presenting = child.rootController.presentingViewController as? UINavigationController {
                presenting.popViewController(animated: animated)
            } else {
                child.rootController.dismiss(animated: animated, completion: nil)
            }
            self.remove(child)
        }
    }
    
    final func finish(animated: Bool = true) {
        finishPipe.input.send(value: animated)
        finishPipe.input.sendCompleted()
    }
}
