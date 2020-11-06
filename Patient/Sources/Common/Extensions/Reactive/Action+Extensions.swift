//
//  Action+Extensions.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/5/18.
//

import Foundation
import ReactiveSwift
import Result

extension Action where Output == Void {
    static var empty: Action {
        return Action(execute: emptyMethod)
    }
    
    static private func emptyMethod(_ input: Input) -> SignalProducer<Output, Error> {
        return .executingEmpty
    }
}
