//
//  Signal+Trigger.swift
//  LetsSurf
//
//  Created by Ihor Teltov on 2/1/18.
//  Copyright © 2018 Cleveroad Inc. All rights reserved.
//

import ReactiveSwift
import Result

extension Signal where Error == Never {
    func trigger() -> Signal<Void, Error> {
        return map { _ in }
    }
}

extension SignalProducer where Error == Never {
    func trigger() -> SignalProducer<Void, Error> {
        return map { _ in }
    }
}
