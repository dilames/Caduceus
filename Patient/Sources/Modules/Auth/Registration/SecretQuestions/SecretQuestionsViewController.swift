//
//  SecretQuestionsViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/8/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import VisualEffectView

final class SecretQuestionsViewController: BaseViewController, ViewModelContainer {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonBlurView: VisualEffectView!
    @IBOutlet private weak var doneButton: GradientButton!
    @IBOutlet private weak var buttonBlurViewBottom: NSLayoutConstraint!

    private lazy var titleView: NavigationTitleView = setupTitleView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewDelegate()
        setupController()
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomInset = view.safeAreaInsets.bottom + buttonBlurView.bounds.height + buttonBlurViewBottom.constant
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.registerNib(for: SuggestionsInputTVCell.self)
        tableView.registerNib(for: SuggestionsTVCell.self)
        tableView.registerNib(for: CommonHeaderView.self)
    }
    
    private func setupController() {
        tableView.adjustInsetsOnKeyboardNotification(extraBottomInset: buttonBlurView.bounds.height)
        buttonBlurView.blurRadius = 10
        buttonBlurView.scale = 1
        navigationItem.titleView = titleView
    }
    
    private func setupTableViewDelegate() {
        tableView.reactive.delegate.rowHeight = { [weak self] indexPath in
            guard let `self` = self else { return 0.0 }
            return self.viewModel.cellViewModel(at: indexPath).rowHeight
        }
        tableView.reactive.delegate.headerView = { [weak self] section in
            guard let `self` = self else { return nil }
            return self.viewModel.sectionType(for: section).header.view
        }
        tableView.reactive.delegate.footerView = { _ in
            return UIView(frame: .zero)
        }
        tableView.reactive.delegate.headerHeight = { [weak self] section in
            guard let `self` = self else { return 0.0 }
            return self.viewModel.sectionType(for: section).header.height
        }
        tableView.reactive.delegate.footerHeight = { [weak self] section in
            guard let `self` = self else { return 0.0 }
            return self.viewModel.sectionType(for: section).footer.height
        }
        tableView.reactive.rowSelectionIndexPaths.observeValues {
            $0.deselectRow(at: $1, animated: true)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.reactive
            .keyboardChange
            .take(during: reactive.lifetime)
            .observeValues { [weak self] context in
                guard let strongSelf = self else { return }
                let bottomInset = strongSelf.view.bounds.height - context.endFrame.origin.y + UIApplication.shared.statusBarFrame.height
                strongSelf.buttonBlurViewBottom.constant = bottomInset
                UIView.animate(withDuration: context.animationDuration, animations: {
                    strongSelf.buttonBlurView.superview?.layoutSubviews()
                })
        }
    }
    
    private func setupTitleView() -> NavigationTitleView {
        let view = NavigationTitleView.instantiateFromNib()
        view.title = R.string.localizable.chooseQuestion()
        return view
    }
    
    func didSetViewModel(_ viewModel: SecretQuestionsViewModel, lifetime: Lifetime) {
        let rowSelectionIndexPaths = tableView.reactive.rowSelectionIndexPaths.map { $0.indexPath }
        let input = SecretQuestionsViewModel.Input(didTapItem: rowSelectionIndexPaths)
        let output = viewModel.transform(input)
        doneButton.reactive.pressed = CocoaAction(output.done)
        doneButton.reactive.isEnabled <~ output.answerNotEmpty
        titleView.reactive.activity <~ output.isExecuting
        output.suggestionsChanged.observeValues { [weak self] in
            guard let strongSelf = self else { return }
            let shouldInsert = strongSelf.tableView.numberOfSections == 1
            shouldInsert ?
                strongSelf.tableView.insertSections(.init(integer: 1), with: .fade)
                :
                strongSelf.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension SecretQuestionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModelType = viewModel.cellViewModel(at: indexPath)
        switch cellViewModelType {
        case .input(let viewModel):
            let cell = tableView.dequeueReusableCell(cellClass: SuggestionsInputTVCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .suggestion(let viewModel):
            let cell = tableView.dequeueReusableCell(cellClass: SuggestionsTVCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
}
