//
//  DetailedNewsViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/5/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

final class DetailedNewsViewModel: ViewModel {
    
    struct Output {
        let close: ActionHandler
    }
    
    struct Handlers {
        let close: ActionHandler
    }
    
    private let handlers: Handlers
    
    init(handlers: Handlers) {
        self.handlers = handlers
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func transform(_ input: ()) -> DetailedNewsViewModel.Output {
        let close: ActionHandler = .empty
        handlers.close <~ close.values
        return Output(close: close)
    }
}
