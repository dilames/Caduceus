//
//  SectionedDataSource.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/4/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Dwifft

protocol SectionedDataSource: NSObjectProtocol {
    associatedtype CellViewModel: Equatable
    associatedtype SectionViewModel: Equatable
    var sectionedValues: MutableProperty<SectionedValues<DataSourceSection<SectionViewModel>, CellViewModel>> { get set }
}

extension Reactive where Base: SectionedDataSource {
    /// Binding Target for sectionedValues
    var sectionedValues: BindingTarget<SectionedValues<DataSourceSection<Base.SectionViewModel>, Base.CellViewModel>> {
        return makeBindingTarget {
            $0.sectionedValues.value = $1
        }
    }
}
