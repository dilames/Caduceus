//
//  NewsViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/3/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class NewsViewController: BaseViewController, NewsTransitionSourceController {
    
    typealias DataSource = CollectionViewDataSource<NewsCellViewModel, NewsSectionViewModel>

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var newsLayout: GridCollectionViewFlowLayout!
    
    var selectedIndexPath: IndexPath?
    private lazy var dataSource: DataSource = setupDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupCollectionView()
    }

    private func setupController() {
        navigationController?.navigationBar.barTintColor = nil
        let rightItem = UIBarButtonItem(image: #imageLiteral(resourceName: "pinned-news-icon"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func setupCollectionView() {
        collectionView.registerNib(for: NewsSectionHeader.self, forSupplementaryViewOfKind: .header)
        collectionView.registerNib(for: NewsCVCell.self)
    }
    
    private func setupDataSource() -> DataSource {
        return CollectionViewDataSource(
            collectionView: collectionView,
            cellsTypes: NewsCVCell.self,
            headersTypes: NewsSectionHeader.self)
    }
}

// MARK: - ViewModelContainer
extension NewsViewController: ViewModelContainer {
    func didSetViewModel(_ viewModel: NewsViewModel, lifetime: Lifetime) {
        let didTapItem = collectionView.reactive.itemSelectionIndexPaths.map {$0.indexPath}
        let input = NewsViewModel.Input(didTapItem: didTapItem)
        let output = viewModel.transform(input)
        dataSource.reactive.sectionedValues <~ output.news
        changeSelectedIndexPath()
    }
    
    private func changeSelectedIndexPath() {
        collectionView.reactive
            .itemSelectionIndexPaths
            .map {$0.indexPath}
            .take(during: reactive.lifetime)
            .observeValues { [weak self] indexPath in
                self?.selectedIndexPath = indexPath
        }
    }
}
