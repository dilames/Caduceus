//
//  PlainTableViewDisplayManager+Reactive.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/18/18.
//

import Foundation
import ReactiveSwift
import Result

extension Reactive where Base: NSObject & SequenceDisplayManager {
    var values: BindingTarget<[Base.CellViewModelType]> {
        return makeBindingTarget {
            $0.values = $1
        }
    }
}
