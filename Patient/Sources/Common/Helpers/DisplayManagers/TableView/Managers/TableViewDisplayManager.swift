//
//  TableViewDisplayManager.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import UIKit
import ReactiveSwift
import Result
import Dwifft

typealias EquatableViewModel = ViewModel & Equatable
private typealias Protocols =  SectionedTableDisplayManager &
    UITableViewDataSource & UITableViewDelegate

class TableViewDisplayManager<SectionVM: EquatableViewModel, CellVM: EquatableViewModel>: NSObject, Protocols {
 
    // MARK: - Types
    
    typealias CellTypeFactory = (IndexPath, SectionViewModel<SectionVM, CellVM>) -> UITableViewCell.Type
    typealias HeaderTypeFactory = (Int) -> UIView.Type?
    typealias SectionViewModels = [SectionViewModel<SectionVM, CellVM>]
    
    // MARK: - Properties
    
    private let tableView: UITableView
    private let cellTypeFactory: CellTypeFactory
    private let headerTypeFactory: HeaderTypeFactory?
    private let diffsAnimation: UITableViewRowAnimation
    
    // MARK: - Data Properties
    
    var sectionsViewModels: SectionViewModels = [] {
        didSet {
            _sectionsViewModels.value = sectionsViewModels
        }
    }
    
    private let _sectionsViewModels: MutableProperty<SectionViewModels> = .init([])
    
    weak var dataSource: TableViewDisplayManagerDataSource?
    
    // MARK: - Lifecyle
    
    init(tableView: UITableView,
         cellTypeFactory: @escaping CellTypeFactory,
         headerTypeFactory: HeaderTypeFactory? = nil,
         diffsAnimation: UITableViewRowAnimation = .fade) {
        self.tableView = tableView
        self.cellTypeFactory = cellTypeFactory
        self.headerTypeFactory = nil
        self.diffsAnimation = diffsAnimation
        super.init()
        setup()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionViewModel = self.sectionViewModel(in: indexPath.section)
        let cellType = cellTypeFactory(indexPath, sectionViewModel)
        let cell = tableView.dequeueReusableCell(cellClass: cellType, for: indexPath)
        if let cell = cell as? UITableViewCell & AnyReusableViewModelContainer {
            cell.anyViewModel = cellViewModel(at: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sectionsViewModels.value[section].cells.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return _sectionsViewModels.value.count
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let headerTypeFactory = headerTypeFactory,
            let headerType = headerTypeFactory(section).self else {
                return UIView(frame: .zero)
        }
        let header = tableView.dequeueReusableHeaderFooterView(cellClass: headerType)
        if let header = header as? UIView & AnyReusableViewModelContainer {
            header.anyViewModel = sectionViewModel(in: section).section
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource?.displayManager(self, heightForRowAt: indexPath) ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource?.displayManager(self, heightForHeaderIn: section) ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource?.displayManager(self, heightForFooterIn: section) ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {}
}

// MARK: - Public
extension TableViewDisplayManager {
    func sectionViewModel(in section: Int) -> SectionViewModel<SectionVM, CellVM> {
        return _sectionsViewModels.value[section]
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CellVM {
        return _sectionsViewModels.value[indexPath.section].cells[indexPath.row]
    }
}

// MARK: - Private
extension TableViewDisplayManager {
    private func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        observeAndApplyChanges()
    }
    
    private func observeAndApplyChanges() {
    	_sectionsViewModels
        	.combinePrevious(.init([]))
        	.producer
            .take(during: reactive.lifetime)
            .startWithValues { [weak self] oldValues, newValues in
                guard let strongSelf = self else { return }
                let oldSectionedValues = SectionedValues(oldValues.map { ($0.section, $0.cells) })
                let newSectionedValues = SectionedValues(newValues.map { ($0.section, $0.cells) })
                let diffSteps = Dwifft.diff(lhs: oldSectionedValues, rhs: newSectionedValues)
                if strongSelf.tableView.visibleCells.isEmpty {
                    strongSelf.tableView.reloadData()
                    return
                }
                if oldSectionedValues == newSectionedValues {
                    strongSelf.tableView.reloadData()
                    return
                }
               	 strongSelf.tableView.performBatchUpdates({
                    strongSelf.apply(diffSteps)
                }, completion: nil)
        }
    }
    
    private func apply(_ diffSteps: [SectionedDiffStep<SectionVM, CellVM>]) {
        if diffSteps.isEmpty {
            let sections = 0 ..< numberOfSections(in: tableView)
            tableView.reloadSections(.init(integersIn: sections), with: diffsAnimation)
            return
        }
        diffSteps.forEach {
            switch $0 {
            case .insert(let section, let row, _):
                let indexPath = IndexPath(row: row, section: section)
                tableView.insertRows(at: [indexPath], with: diffsAnimation)
            case .delete(let section, let row, _):
                let indexPath = IndexPath(row: row, section: section)
                tableView.deleteRows(at: [indexPath], with: diffsAnimation)
            case .sectionInsert(let section, _):
                tableView.insertSections(.init(integer: section), with: diffsAnimation)
            case .sectionDelete(let section, _):
                tableView.deleteSections(.init(integer: section), with: diffsAnimation)
            }
        }
    }
}
