//
//  ChooseMapController.swift
//  Patient
//
//  Created by Andrew Chersky on 5/30/18.
//

import ReactiveSwift
import ReactiveCocoa

final class ChooseMapController: BaseViewController {
    
    typealias ChooseMapDisplayManager = TableViewDisplayManager<EmptySectionViewModel, ChooseMapStyleCellViewModel>
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var displayManager: ChooseMapDisplayManager = setupDisplayManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    private func setupDisplayManager() -> ChooseMapDisplayManager {
        let manager = ChooseMapDisplayManager(
            tableView: tableView,
            cellTypeFactory: chooseMapStyleCellTypeFactory,
            diffsAnimation: .none)
        manager.dataSource = self
        return manager
    }
    
    private var chooseMapStyleCellTypeFactory: ChooseMapDisplayManager.CellTypeFactory {
        return { _, _ in return ChooseMapStyleTVCell.self }
    }
    
    private func registerCells() {
        tableView.registerNibs(for: [ChooseMapStyleTVCell.self])
    }
}

extension ChooseMapController: ViewModelContainer {
    func didSetViewModel(_ viewModel: ChooseMapViewModel, lifetime: Lifetime) {
        let didSelectIndexPath = displayManager.reactive.rowSelectionIndexPaths.map { $0.indexPath }
        let input = ChooseMapViewModel.Input(didSelectIndexPath: didSelectIndexPath)
        let output = viewModel.transform(input)
        displayManager.reactive.sectionsViewModels <~ output.sectionViewModels
    }
}

// MARK: - TableViewDisplayManagerDataSource
extension ChooseMapController: TableViewDisplayManagerDataSource {
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager, heightForHeaderIn section: Int) -> CGFloat {
        return 0.0
    }
}
