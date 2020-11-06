//
//  FamilyListViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/31/18.
//

import Foundation
import Domain
import ReactiveSwift
import ReactiveCocoa
import Result

final class FamilyListViewModel: ViewModel {
    
    // MARK: - Types
    
    typealias UseCases = HasFamilyListUseCase
    
    struct Input {
        let selectedIndexPaths: Signal<IndexPath, Never>
    }
    
    struct Output {
        let viewModels: Property<[FamilyListCellViewModel]>
    }
    
    struct Handlers {
        let didSelectUser: Action<User, Void, Never>
        let didTapAddNewMember: ActionHandler
    }
    
    // MARK: - Properties
    
    private let useCases: UseCases
    private let handlers: Handlers
    
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
        let addNewCellViewModel = self.addNewCellViewModel()
        let fetchMembersProducer = useCases.familyList.fetchFamilyMembers()
        let membersProducer = fetchMembersProducer
            .map { $0.map { FamilyListCellViewModel.member(self.memberCellViewModel(with: $0)) } }
            .map { (cellViewModels) -> [FamilyListCellViewModel] in
                var resultArray = cellViewModels
                resultArray.append(addNewCellViewModel)
                return resultArray
            }
            .flatMapError { _ in .init(value: []) }
        membersProducer.start()
        let members = Property(initial: [addNewCellViewModel], then: membersProducer)
        bindHandlers(to: input, withLatest: fetchMembersProducer)
        return Output(viewModels: members)
    }
    
    private func bindHandlers(to input: Input,
                              withLatest patients: SignalProducer<[Patient], AnyError>) {
        let NeverPatients = patients.flatMapError { _ in .init(value: []) }
        
        let selectedMember = input.selectedIndexPaths
            .map { $0.row }
        	.withLatest(from: NeverPatients)
            .map { $1[safe: $0]?.asUser }
            .skipNil()
        
        handlers.didSelectUser <~ selectedMember
    }
}

// MARK: - CellViewModels Setup
extension FamilyListViewModel {
    private func memberCellViewModel(with patient: Patient) -> FamilyMemberCellViewModel {
        let testURL = URL(string: "https://i.pinimg.com/736x/96/c1/77/96c177a8fd610c76394dd932aa6369a8--man-bun-undercut-men-haircut-undercut.jpg")
        return FamilyMemberCellViewModel(
            photoURL: testURL,
            name: "John Smith")
    }
    
    private func addNewCellViewModel() -> FamilyListCellViewModel {
        return .addMember(AddNewFamilyMemberCellViewModel(buttonAction: handlers.didTapAddNewMember))
    }
}
