//
//  SettingsController.swift
//  Patient
//
//  Created by Andrew Chersky on 5/18/18.
//

import ReactiveSwift
import ReactiveCocoa

final class SettingsController: BaseViewController {
    
    typealias SettingsDisplayManager = TableViewDisplayManager<EmptySectionViewModel, SettingCellViewModel>
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var displayManager: SettingsDisplayManager = setupDisplayManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    private func setupDisplayManager() -> SettingsDisplayManager {
        let manager = SettingsDisplayManager(
            tableView: tableView,
            cellTypeFactory: settingCellTypeFactory,
            diffsAnimation: .none)
        manager.dataSource = self
        return manager
    }
    
    private var settingCellTypeFactory: SettingsDisplayManager.CellTypeFactory {
        return { _, _ in return SelectionTVCell.self }
    }
    
    private func registerCells() {
        tableView.registerNibs(for: [SelectionTVCell.self])
    }
}

extension SettingsController: ViewModelContainer {
    func didSetViewModel(_ viewModel: SettingsViewModel, lifetime: Lifetime) {
        let didSelectIndexPath = displayManager.reactive.rowSelectionIndexPaths.map { $0.indexPath }
        let input = SettingsViewModel.Input(didSelectIndexPath: didSelectIndexPath)
        let output = viewModel.transform(input)
        displayManager.reactive.sectionsViewModels <~ output.sectionViewModels
    }
}

// MARK: - TableViewDisplayManagerDataSource
extension SettingsController: TableViewDisplayManagerDataSource {
    
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager, heightForHeaderIn section: Int) -> CGFloat {
        return 28.0
    }
    
}
