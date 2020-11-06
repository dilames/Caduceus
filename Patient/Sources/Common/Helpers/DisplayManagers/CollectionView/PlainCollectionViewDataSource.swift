//
//  CollectionViewDataSource.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/6/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import Dwifft

typealias PlainCollectionViewDataSourceParent<CellViewModel: ViewModel & Equatable> = CollectionViewDataSource<CellViewModel, EmptySectionViewModel>

final class PlainCollectionViewDataSource<CellViewModel: ViewModel & Equatable>: PlainCollectionViewDataSourceParent<CellViewModel>, PlainDataSource {
    
    var values: MutableProperty<[CellViewModel]> = .init([])
    
    override init(collectionView: UICollectionView, cellsTypes: UICollectionViewCell.Type, headersTypes: UICollectionReusableView.Type?) {
        super.init(collectionView: collectionView, cellsTypes: cellsTypes, headersTypes: headersTypes)
        setup()
    }
    
    override init(collectionView: UICollectionView, cellTypeFactory: @escaping CellTypeFactory, headerTypeFactory: SectionHeaderFooterTypeFactory?) {
        super.init(collectionView: collectionView, cellTypeFactory: cellTypeFactory, headerTypeFactory: headerTypeFactory)
        setup()
    }
    
    private func setup() {
        let values = sectionedValues.map { $0.sectionsAndValues.map { $0.1 }.flatMap{$0} }
        let mutableValues = MutableProperty<[CellViewModel]>([])
        mutableValues <~ values.producer
        self.values = mutableValues
    }
}
