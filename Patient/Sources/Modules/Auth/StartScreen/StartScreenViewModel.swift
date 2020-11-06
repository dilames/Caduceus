//
//  StartScreenViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/5/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

final class StartScreenViewModel: ViewModel {
    
    struct Output {
        let login: ActionHandler
        let register: ActionHandler
        let enterAsGuest: ActionHandler
    }
    
    struct Handlers {
        let login: ActionHandler
        let register: ActionHandler
        let enterAsGuest: ActionHandler
    }
    
    private let handlers: Handlers
    
    init(handlers: Handlers) {
        self.handlers = handlers
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func transform(_ input: Void) -> Output {
        let login: ActionHandler = .empty
        let register: ActionHandler = .empty
        let enterAsGuest: ActionHandler = .empty
        handlers.login <~ login.values
        handlers.register <~ register.values
        handlers.enterAsGuest <~ enterAsGuest.values
        return Output(login: login, register: register, enterAsGuest: enterAsGuest)
    }
}
