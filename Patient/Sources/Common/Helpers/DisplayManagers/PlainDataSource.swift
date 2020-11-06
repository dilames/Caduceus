//
//  PlainDataSource.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/6/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

protocol PlainDataSource: NSObjectProtocol {
    associatedtype CellViewModel
    var values: MutableProperty<[CellViewModel]> { get set }
}

extension Reactive where Base: PlainDataSource {
    var values: BindingTarget<[Base.CellViewModel]> {
        return makeBindingTarget {
            $0.values.value = $1
        }
    }
}
