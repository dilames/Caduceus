//
//  ObservableRepository+Reactive.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/25/18.
//

import Foundation
import ReactiveSwift
import Result

extension Reactive where Base: ObservableRepository {
    func observeChanges() -> SignalProducer<ObservableRepositoryChange, Never> {
        return SignalProducer { observer, lifetime in
            let cancellable = self.base.observeChanges {
                observer.send(value: $0)
            }
            lifetime.observeEnded {
                cancellable?.cancel()
            }
        }
    }
}
