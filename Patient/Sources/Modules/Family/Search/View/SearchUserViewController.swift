//
//  SearchUserViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 6/1/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class SearchUserViewController: BaseViewController {

    typealias DisplayManager = PlainTableViewDisplayManager<SearchUserCellViewModel>
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var searchController: UISearchController = setupSearchController()
    private lazy var displayManger: DisplayManager = setupDisplayManager()
    private lazy var placeholder: SearchPlaceholderView = setupPlaceholderView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTableView()
    }
}

// MARK: - Setup
extension SearchUserViewController {
    private func setupController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        placeholder.alpha = 1.0
    }
    
    private func setupTableView() {
        tableView.registerNib(for: SearchUserTVCell.self)
        tableView.adjustInsetsOnKeyboardNotification()
    }
    
    private func setupSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }
    
    private func setupDisplayManager() -> DisplayManager {
        let displayManager = DisplayManager(
            tableView: tableView,
            cellTypeFactory: { _, _ in SearchUserTVCell.self })
        displayManager.dataSource = self
        return displayManager
    }
    
    private func setupPlaceholderView() -> SearchPlaceholderView {
        let view = SearchPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.constrainToSuperview()
        self.view.bringSubview(toFront: view)
        return view
    }
}

// MARK: - ViewModelContainer
extension SearchUserViewController: ViewModelContainer {
    func didSetViewModel(_ viewModel: SearchUserViewModel, lifetime: Lifetime) {
        let searchText = searchController.searchBar.reactive.continuousTextValues.map { $0 ?? "" }
        let cancelSearch = searchController.searchBar.reactive.cancelButtonClicked.map { _ in return "" }
        let searchContinuousValues = Signal.merge(searchText, cancelSearch)
        let selectedIndexPaths = displayManger.reactive.rowSelectionIndexPaths.map { $0.indexPath }
        
        let input = SearchUserViewModel.Input(
            searchContinuousValues: searchContinuousValues,
            selectedIndexPaths: selectedIndexPaths)
        
        let output = viewModel.transform(input)
        displayManger.reactive.values <~ output.cellViewModels
        
        placeholder.reactive.hide(animated: true) <~ searchContinuousValues.map { !$0.isEmpty }
    }
}

// MARK: - TableViewDisplayManagerDataSource
extension SearchUserViewController: TableViewDisplayManagerDataSource {
    func displayManager(_ displayManager: TableViewDisplayManagerDataSource.DisplayManager,
                        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
