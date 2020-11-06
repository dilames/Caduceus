//
//  ProfileViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class ProfileViewController: BaseViewController {

    typealias DisplayManager = PlainTableViewDisplayManager<ProfileCellViewModel>
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var displayManager: DisplayManager = self.setupDisplayManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNib(for: ProfileTVCell.self)
        tableView.registerNib(for: ProfileInfoTVCell.self)
    }
    
    private func setupDisplayManager() -> DisplayManager {
        let displayManager = DisplayManager(
            tableView: tableView,
            cellTypeFactory: cellTypeFactory,
            diffsAnimation: .none)
        displayManager.dataSource = self
        return displayManager
    }
    
    private var cellTypeFactory: DisplayManager.CellTypeFactory {
        return { (indexPath, sectionViewModel) -> UITableViewCell.Type in
            let viewModel = sectionViewModel.cells[indexPath.row]
            switch viewModel {
            case .mainInfo:
                return ProfileTVCell.self
            case .email, .gender, .birthDate:
                return ProfileInfoTVCell.self
            }
        }
    }
}

// MARK: - ViewModelContainer
extension ProfileViewController: ViewModelContainer {
    func didSetViewModel(_ viewModel: ProfileViewModel, lifetime: Lifetime) {
        let selectedIndexPaths = displayManager.reactive.rowSelectionIndexPaths.map { $0.indexPath }
        let input = ProfileViewModel.Input(selectedIndexPaths: selectedIndexPaths)
        let output = viewModel.transform(input)
        displayManager.reactive.sectionsViewModels <~ output.sectionViewModels
    }
}

// MARK: - TableViewDisplayManagerDataSource
extension ProfileViewController: TableViewDisplayManagerDataSource {
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager,
                        heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = self.displayManager.cellViewModel(at: indexPath)
        switch viewModel {
        case .mainInfo:
            return 100
        case .email, .gender, .birthDate:
            return 50
        }
    }
    
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager,
                        heightForHeaderIn section: Int) -> CGFloat {
        return 20
    }
}
