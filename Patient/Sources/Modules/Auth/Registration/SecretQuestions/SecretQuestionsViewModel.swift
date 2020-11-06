//
//  SecretQuestionsViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/8/18.
//

import Foundation
import Domain
import ReactiveSwift
import ReactiveCocoa
import Result

final class SecretQuestionsViewModel: ViewModel {
    
    // MARK: - Types
    
    typealias UseCases = HasSecretQuestionsUseCase
    
    struct Input {
        let didTapItem: Signal<IndexPath, Never>
    }
    
    struct Output {
        let done: ActionHandler
        let suggestionsChanged: SignalTrigger
        let answerNotEmpty: Property<Bool>
        let isExecuting: Property<Bool>
    }
    
    struct Handlers {
        let done: ActionHandler
    }
    
    // MARK: - Variables
    
    private let useCases: UseCases
    private let handlers: Handlers
    private let selectedQuestion: String?
    private let observer: Signal<String?, Never>.Observer
    
    private let inputViewModel: SuggestionsInputCellViewModel
    private let suggestionsCellViewModels: MutableProperty<[SuggestionsCellViewModel]>
    
    private var items: MutableProperty<[SecretQuestionsItemType]>
    
    // MARK: - Lifecycle
    
    init(useCases: UseCases, handlers: Handlers, selectedQuestion: String?, observer: Signal<String?, Never>.Observer) {
        self.useCases = useCases
        self.handlers = handlers
        self.selectedQuestion = selectedQuestion
        self.observer = observer
        
        inputViewModel = .init(text: selectedQuestion ?? "")
        suggestionsCellViewModels = .init([])
        items = MutableProperty(
            [SecretQuestionsItemType(sectionType: .input,
                                     viewModels: [.input(inputViewModel)])]
        )
    }
    
    deinit {
        observer.send(value: nil)
        observer.sendCompleted()
        print("\(self) \(#function)")
    }
    
    // MARK: - Transform
    
    func transform(_ input: Input) -> Output {
        let fetch = Action(execute: useCases.secretQuestions.fetch)
        suggestionsCellViewModels <~ fetch.values.map {$0.map {SuggestionsCellViewModel(text: $0)}}
        
        items <~ suggestionsCellViewModels.map { [weak self] in
            guard let strongSelf = self else { return [] }
            var itemTypes: [SecretQuestionsItemType] = []
            itemTypes.append(.init(sectionType: .input, viewModels: [.input(strongSelf.inputViewModel)]))
            itemTypes.append(.init(
                sectionType: .suggestions,
                viewModels: $0.map {.suggestion($0)}))
            return itemTypes
        }
      
        let textOfSelectedCell = input.didTapItem
            .map { [weak self] (indexPath) -> String? in
                guard let strongSelf = self else { return nil }
                let viewModel = strongSelf.cellViewModel(at: indexPath)
                if case .suggestion(let viewModel) = viewModel {
                    return viewModel.text.value
                }
                return nil
            }
            .skipNil()
        
        inputViewModel.text <~ textOfSelectedCell
        
        let form = Property(initial: selectedQuestion, then: inputViewModel.text.signal)
        let done = Action(state: form, execute: choose)
        handlers.done <~ done.values
        fetch.apply().start()
        
        let answerNotEmpty = inputViewModel.text.map {!$0.isEmpty}
        
        return Output(
            done: done,
            suggestionsChanged: items.signal.mapToVoid(),
            answerNotEmpty: Property(answerNotEmpty),
            isExecuting: fetch.isExecuting
        )
    }
    
    private func choose(question: String?) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak self] observer, _ in
            self?.observer.send(value: question)
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
}

// MARK: - ViewModel DataSource
extension SecretQuestionsViewModel {
    func cellViewModel(at indexPath: IndexPath) -> SecretQuestionViewModelType {
        let section = items.value[indexPath.section]
        return section.viewModels[indexPath.row]
    }
    
    func sectionType(for section: Int) -> SecretQuestionsSectionType {
        return items.value[section].sectionType
    }
    
    var numberOfSections: Int {
        var count = items.value.count
        if items.value[index(of: .suggestions)].viewModels.isEmpty {
            count -= 1
        }
        return count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let section = items.value[section]
        return section.viewModels.count
    }
    
    func index(of sectionType: SecretQuestionsSectionType) -> Int {
        return sectionType.index
    }
}
