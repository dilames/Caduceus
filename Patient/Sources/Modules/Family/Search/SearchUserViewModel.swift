//
//  SearchUserViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 6/1/18.
//

import Foundation
import Domain
import ReactiveSwift
import ReactiveCocoa
import Result

final class SearchUserViewModel: ViewModel {
    
    // MARK: - Types
    
    typealias UseCases = HasSearchUsersUseCase
    
    struct Input {
        let searchContinuousValues: Signal<String, Never>
        let selectedIndexPaths: Signal<IndexPath, Never>
    }
    
    struct Output {
        let cellViewModels: Property<[SearchUserCellViewModel]>
    }
    
    struct Handlers {
        let didSelectUser: Action<User, Void, Never>
        let didTapOpenProfile: Action<User, Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCases: UseCases
    private let handlers: Handlers
    private lazy var searchUsers = Action(execute: useCases.searchUsers.search)
    
    // MARK: - Lifecycle
    
    init(useCases: UseCases, handlers: Handlers) {
        self.useCases = useCases
        self.handlers = handlers
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    // MARK: - ViewModel
    
    func transform(_ input: Input) -> Output {
        searchUsers <~ input.searchContinuousValues.debounce(0.2, on: QueueScheduler.main)
        let searchViewModels = searchUsers.values.map { self.cellViewModels(with: $0) }
        let cellViewModels = Property(initial: [], then: searchViewModels)
        
        handlers.didSelectUser <~ input.selectedIndexPaths
            .map { $0.row }
        	.withLatest(from: searchUsers.values)
            .map { $1[$0] }
        
        return Output(cellViewModels: cellViewModels)
    }
    
    private func toggleProfileAction(_ user: User) -> ProducerTrigger {
        return handlers.didTapOpenProfile.apply(user).flatMapError { _ in .empty }
    }
}

// MARK: - Rrivate
extension SearchUserViewModel {
    private func cellViewModels(with users: [User]) -> [SearchUserCellViewModel] {
        let testURL = URL(string: "https://i.pinimg.com/736x/96/c1/77/96c177a8fd610c76394dd932aa6369a8--man-bun-undercut-men-haircut-undercut.jpg")
        return users.map {
            SearchUserCellViewModel(
                id: $0.id,
                photoURL: testURL,
                fullName: ($0.firstName ?? "") + " " + ($0.lastName ?? ""),
                birthDate: Date(timeIntervalSince1970: 0),
                phone: "+380956329397",
                infoAction: .init(state: Property(value: $0), execute: toggleProfileAction))
        }
        
    }
}
