//
//  SideMenuController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import ReactiveSwift
import ReactiveCocoa
import VisualEffectView

final class SideMenuController: BaseViewController {
    
    typealias DisplayManager = TableViewDisplayManager<EmptySectionViewModel, SideMenuCellViewModel>
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var statusBarBlurView: VisualEffectView!
    
    private lazy var displayManager: DisplayManager = setupDisplayManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        registerCells()
    }

    private func setupDisplayManager() -> DisplayManager {
        let displayManager = DisplayManager(
            tableView: tableView,
            cellTypeFactory: menuCellTypeFactory,
            diffsAnimation: .none)
        displayManager.dataSource = self
        return displayManager
    }
    
    private var menuCellTypeFactory: DisplayManager.CellTypeFactory {
        return { indexPath, sectionViewModel in
            let cellViewModel = sectionViewModel.cells[indexPath.row]
            switch cellViewModel {
            case .profile:
                return SideMenuProfileTVCell.self
            case .settings, .family:
                return SideMenuCommonTVCell.self
            }
        }
    }
    
    private func setupController() {
        statusBarBlurView.blurRadius = 10
        statusBarBlurView.scale = 1
    }
    
    private func registerCells() {
        tableView.registerNib(for: SideMenuCommonTVCell.self)
        tableView.registerNib(for: SideMenuProfileTVCell.self)
    }
    
    private func removeOuterSeparators(of cell: UITableViewCell) {
        let subviews = cell.subviews
        guard subviews.count >= 3 else {
            return
        }
        
        for subview in subviews where NSStringFromClass(subview.classForCoder) == "_UITableViewCellSeparatorView" {
            subview.removeFromSuperview()
        }
    }
}

// MARK: - ViewModelContainer
extension SideMenuController: ViewModelContainer {
    func didSetViewModel(_ viewModel: SideMenuViewModel, lifetime: Lifetime) {
        let didSelectIndexPath = displayManager.reactive.rowSelectionIndexPaths.map { $0.indexPath }
        let input = SideMenuViewModel.Input(didSelectIndexPath: didSelectIndexPath)
        let output = viewModel.transform(input)
        displayManager.reactive.sectionsViewModels <~ output.sectionsViewModels
    }
}

// MARK: - TableViewDisplayManagerDataSource
extension SideMenuController: TableViewDisplayManagerDataSource {
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager,
                        heightForHeaderIn section: Int) -> CGFloat {
        let indexPath = IndexPath(row: 0, section: section)
        let cellViewModel = self.displayManager.cellViewModel(at: indexPath)
        switch cellViewModel {
        case .profile:
            return 15
        case .family:
            return 30
        case .settings:
            return .leastNonzeroMagnitude
        
        }
    }
    
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager,
                        heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.displayManager.cellViewModel(at: indexPath)
        switch cellViewModel {
        case .profile:
            return 78
        case .settings, .family:
            return 50
        }
    }
}
