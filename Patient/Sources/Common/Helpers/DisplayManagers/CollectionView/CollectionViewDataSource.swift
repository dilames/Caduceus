//
//  CollectionViewDataSource.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/3/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import Dwifft

private typealias DataSourceProtocols = UICollectionViewDataSource & SectionedDataSource

class CollectionViewDataSource<CellViewModel: ViewModel & Equatable, SectionViewModel: ViewModel & Equatable>: NSObject, DataSourceProtocols {

    typealias CellTypeFactory = (_ indexPath: IndexPath) -> UICollectionViewCell.Type
    typealias SectionHeaderFooterTypeFactory = (_ indexPath: IndexPath) -> UICollectionReusableView.Type?

    // MARK: - Variables
    
    private let collectionView: UICollectionView
    private let cellTypeFactory: CellTypeFactory
    private let headerTypeFactory: SectionHeaderFooterTypeFactory?
    
    var sectionedValues: MutableProperty<SectionedValues<DataSourceSection<SectionViewModel>, CellViewModel>>
    
    weak var delegate: CollectionViewDataSourceDelegate?
    
    // MARK: - Lifecycle
    
    /// Initializes data source using Factory of cell types
    ///
    /// - Parameters:
    ///   - collectionView: dataSource's UICollectionView
    ///   - cellTypeFactory: Factory of cells which depends on indexPaths
    ///   - headerTypeFactory: Factory of headers which depends on indexPaths
    init(
        collectionView: UICollectionView,
        cellTypeFactory: @escaping CellTypeFactory,
        headerTypeFactory: SectionHeaderFooterTypeFactory? = nil)
    {
        self.collectionView = collectionView
        self.cellTypeFactory = cellTypeFactory
        self.headerTypeFactory = headerTypeFactory
        sectionedValues = .init(.init())
        super.init()
        setup()
    }
    
    /// Initializes data source using constant cell type
    ///
    /// - Parameters:
    ///   - collectionView: dataSource's UICollectionView
    ///   - cellsTypes: type of cell which will be used for each indexPath
    ///   - headersTypes: type of header which will be used for each indexPath
    init(
        collectionView: UICollectionView,
        cellsTypes: UICollectionViewCell.Type,
        headersTypes: UICollectionReusableView.Type? = nil)
    {
        self.collectionView = collectionView
        self.cellTypeFactory = { _ in cellsTypes.self }
        self.headerTypeFactory = { _ in headersTypes.self }
        sectionedValues = .init(.init())
        super.init()
        setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        collectionView.dataSource = self
        observeChanges()
    }

    /// Observes changes of 'sectionedValues' and applies changes to UICollectionView
	/// If there are no diff steps then reload all UICollectionView sections
    private func observeChanges() {
        sectionedValues
            .combinePrevious(.init())
            .producer
            .startWithValues { [weak self] oldValues, newValues in
                guard let `self` = self else { return }
                let diffSteps = Dwifft.diff(lhs: oldValues, rhs: newValues)
                if oldValues.sectionsAndValues.isEmpty && newValues.sectionsAndValues.isEmpty {
                    self.collectionView.reloadData()
                }
                
                self.collectionView.performBatchUpdates({
                    if diffSteps.isEmpty {
                        let sections = 0 ..< self.numberOfSections(in: self.collectionView)
                        self.collectionView.reloadSections(.init(integersIn: sections))
                        return
                    }
                    diffSteps.forEach {
                        switch $0 {
                        case .insert(let section, let item, _):
                            let indexPath = IndexPath(item: item, section: section)
                            self.collectionView.insertItems(at: [indexPath])
                        case .delete(let section, let item, _):
                            let indexPath = IndexPath(item: item, section: section)
                            self.collectionView.deleteItems(at: [indexPath])
                        case .sectionInsert(let section, _):
                            self.collectionView.insertSections(.init(integer: section))
                        case .sectionDelete(let section, _):
                            self.collectionView.deleteSections(.init(integer: section))
                        }
                    }
                }, completion: nil)
        }
    }
    
    private func cellViewModel(at indexPath: IndexPath) -> CellViewModel {
        return sectionedValues.value.sectionsAndValues[indexPath.section].1[indexPath.item]
    }
    
    private func sectionViewModel(at indexPath: IndexPath) -> SectionViewModel? {
        return sectionedValues.value.sectionsAndValues[indexPath.section].0.headerViewModel
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = cellTypeFactory(indexPath).self
        if let cell = collectionView.dequeueReusableCell(
            cellClass: cellType,
            for: indexPath) as? UICollectionViewCell & AnyReusableViewModelContainer
        {
            cell.anyViewModel = cellViewModel(at: indexPath)
            return cell
        } else {
            fatalError("Cell \(cellType) should conform to \"ReusableViewModelContainer\" protocol")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionedValues.value.sectionsAndValues[section].1.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionedValues.value.sectionsAndValues.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        if
            let headerType = headerTypeFactory?(indexPath).self,
            let cell = collectionView.dequeueReusableSupplementaryView(
                viewClass: headerType,
                ofKind: .header,
                for: indexPath) as? UICollectionReusableView & AnyReusableViewModelContainer
        {
            cell.anyViewModel = sectionViewModel(at: indexPath)
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return delegate?.dataSource?(self, collectionViewCanMoveItemAt: indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.dataSource?(self, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
}

@objc protocol CollectionViewDataSourceDelegate: class {
    @objc optional func dataSource(_ dataSource: UICollectionViewDataSource,
                                   collectionViewCanMoveItemAt indexPath: IndexPath) -> Bool
    @objc optional func dataSource(_ dataSource: UICollectionViewDataSource,
                                   moveItemAt sourceIndexPath: IndexPath,
                                   to destinationIndexPath: IndexPath)
}
