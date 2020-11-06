//
//  CollectionViewDelegate.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/4/18.
//

import UIKit

final class CollectionViewDelegate: NSObject, UICollectionViewDelegate {

    typealias FlagClosure = (_ indexPath: IndexPath) -> Bool
    
    var shouldSelectItem: FlagClosure
    var shouldDeselectItem: FlagClosure
    var shouldHightlightItem: FlagClosure
    
    override init() {
        shouldSelectItem = { _ in true }
        shouldDeselectItem = { _ in true }
        shouldHightlightItem = { _ in true }
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return shouldSelectItem(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return shouldDeselectItem(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return shouldHightlightItem(indexPath)
    }
}
