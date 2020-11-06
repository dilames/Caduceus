//
//  Reactive+UIScrollViews.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/10/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import Extensions

private enum ReactiveDelegateKey {
    static var tableViewDelegate: String = "TableViewReactiveDelegate"
    static var collectionViewDelegate: String = "CollectionViewReactiveDelegate"
}

extension Reactive where Base: UITableView {
    var delegate: TableViewDelegate {
        let delegate: TableViewDelegate? = base.getAssociatedObject(key: &ReactiveDelegateKey.tableViewDelegate)
        if let delegate = delegate {
            base.delegate = delegate
            return delegate
        } else {
            let delegate = TableViewDelegate()
            base.setAssociatedObject(value: delegate, key: &ReactiveDelegateKey.tableViewDelegate, policy: .retain)
            base.delegate = delegate
            return delegate
        }
    }
}

extension Reactive where Base: UICollectionView {
    var delegate: CollectionViewDelegate {
        let delegate: CollectionViewDelegate? = base.getAssociatedObject(key: &ReactiveDelegateKey.collectionViewDelegate)
        if let delegate = delegate {
            base.delegate = delegate
            return delegate
        } else {
            let delegate = CollectionViewDelegate()
            base.setAssociatedObject(value: delegate, key: &ReactiveDelegateKey.collectionViewDelegate, policy: .retain)
            base.delegate = delegate
            return delegate
        }
    }
}

extension Reactive where Base: UITableView {
    typealias TableSignal = Signal<(tableView: UITableView, indexPath: IndexPath), Never>
    var rowSelectionIndexPaths: TableSignal {
        let selector = #selector(TableViewDelegate.tableView(_:didSelectRowAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var rowDeselectionIndexPaths: TableSignal {
        let selector = #selector(TableViewDelegate.tableView(_:didDeselectRowAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var rowBeganDisplayingIndexPaths: TableSignal {
        let selector = #selector(TableViewDelegate.tableView(_:willDisplay:forRowAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var rowEndedDisplayingIndexPaths: TableSignal {
        let selector = #selector(TableViewDelegate.tableView(_:didEndDisplaying:forRowAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    private func transform(_ signal: Signal<[Any?], Never>) -> TableSignal {
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

extension Reactive where Base: UICollectionView {
    typealias CollectionSignal = Signal<(collectionView: UICollectionView, indexPath: IndexPath), Never>
    var itemSelectionIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:didSelectItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var itemDeselectionIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:didDeselectItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var itemBeganDisplayingIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:willDisplay:forItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var itemEndedDisplayingIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:didEndDisplaying:forItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var itemWillBeSelectedAtIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:shouldSelectItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var itemWillBeDeselectedAtIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:shouldDeselectItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var itemWillBeHightlightedAtIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:shouldHighlightItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    var itemWillBeUnhightlightedAtIndexPaths: CollectionSignal {
        let selector = #selector(CollectionViewDelegate.collectionView(_:shouldHighlightItemAt:))
        let signal = delegate.reactive.signal(for: selector)
        return transform(signal)
    }
    
    private func transform(_ signal: Signal<[Any?], Never>) -> CollectionSignal {
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

extension Reactive where Base: UITableView {
    var reloadSection: BindingTarget<Int> {
        return makeBindingTarget {
            $0.reloadSections(IndexSet(integer: $1), with: .fade)
        }
    }
}
