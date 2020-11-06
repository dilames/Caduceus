//
//  FamilyListViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class FamilyListViewController: BaseViewController {

    typealias DisplayManager = PlainTableViewDisplayManager<FamilyListCellViewModel>
    
    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var displayManager: DisplayManager = setupDisplayManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.registerNib(for: FamilyMemberTVCell.self)
        tableView.registerNib(for: AddNewFamilyMemberTVCell.self)
    }
    
    private func setupDisplayManager() -> DisplayManager {
        let displayManager = DisplayManager(
            tableView: tableView,
            cellTypeFactory: cellTypeFactory,
            diffsAnimation: .fade)
        displayManager.dataSource = self
        return displayManager
    }
    
    private var cellTypeFactory: DisplayManager.CellTypeFactory {
        return { indexPath, sectionViewModel in
            switch sectionViewModel.cells[indexPath.row] {
            case .member:
                return FamilyMemberTVCell.self
            case .addMember:
                return AddNewFamilyMemberTVCell.self
            }
        }
    }
}

// MARK: - ViewModelContainer
extension FamilyListViewController: ViewModelContainer {
    func didSetViewModel(_ viewModel: FamilyListViewModel, lifetime: Lifetime) {
        let selectedIndexPaths = displayManager.reactive.rowSelectionIndexPaths.map { $0.indexPath }
        let input = FamilyListViewModel.Input(selectedIndexPaths: selectedIndexPaths)
        let output = viewModel.transform(input)
        displayManager.reactive.values <~ output.viewModels
    }
}

// MARK: - TableViewDisplayManagerDataSource
extension FamilyListViewController: TableViewDisplayManagerDataSource {
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager,
                        heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.displayManager.cellViewModel(at: indexPath)
        switch cellViewModel {
        case .member:
            return 100
        case .addMember:
            return 65
        }
    }
    
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager,
                        heightForHeaderIn section: Int) -> CGFloat {
        return 10
    }
}
