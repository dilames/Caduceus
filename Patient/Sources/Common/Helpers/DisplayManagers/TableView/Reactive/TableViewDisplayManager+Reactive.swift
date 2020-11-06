//
//  TableViewDisplayManager+Reactive.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import UIKit
import ReactiveSwift
import Result
import Extensions

extension Reactive where Base: NSObject & SectionedTableDisplayManager {
    typealias TableSignalCopy = Signal<(dislayManager: Base, indexPath: IndexPath), Never>
    
    var sectionsViewModels: BindingTarget<Base.SectionViewModels> {
        return makeBindingTarget {
            $0.sectionsViewModels = $1
        }
    }
    
    var rowSelectionIndexPaths: TableSignalCopy {
        let selector = #selector(base.tableView(_:didSelectRowAt:))
        let selectorSignal = signal(for: selector)
        return transform(selectorSignal)
    }
    
    var rowDeselectionIndexPaths: TableSignalCopy {
        let selector = #selector(base.tableView(_:didDeselectRowAt:))
        let signal = self.signal(for: selector)
        return transform(signal)
    }
    
    var rowBeganDisplayingIndexPaths: TableSignalCopy {
        let selector = #selector(base.tableView(_:willDisplay:forRowAt:))
        let signal = self.signal(for: selector)
        return transform(signal)
    }
    
    var rowEndedDisplayingIndexPaths: TableSignalCopy {
        let selector = #selector(base.tableView(_:didEndDisplaying:forRowAt:))
        let signal = self.signal(for: selector)
        return transform(signal)
    }
    
    private func transform(_ signal: Signal<[Any?], Never>) -> TableSignalCopy {
        return signal
            .attemptMap { (values) -> Result<IndexPath?, Never> in
                let indexPath = (values.last as? IndexPath)
                return Result(value: indexPath)
            }
            .skipNil()
            .map { indexPath in
                return (self.base, indexPath)
        }
    }
}
