//
//  ChooseMapViewModel.swift
//  Patient
//
//  Created by Andrew Chersky on 5/31/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result
import Domain

final class ChooseMapViewModel: ViewModel {
    
    typealias SectionsViewModels = [SectionViewModel<EmptySectionViewModel, ChooseMapStyleCellViewModel>]
    typealias UseCases = HasSettingsUseCase
    
    struct Input {
        let didSelectIndexPath: Signal<IndexPath, Never>
    }

    struct Output {
        let sectionViewModels: Property<SectionsViewModels>
    }
    
    struct Handlers {
        let didSelectMapStyle: ActionHandler
    }
    
    private let handlers: Handlers
    private let useCases: UseCases
    private let updateMapStyle: Action<MapStyle, Void, Never>
    
    init(useCases: UseCases, handlers: Handlers) {
        self.useCases = useCases
        self.handlers = handlers
        updateMapStyle = Action(execute: useCases.settings.updateMapStyle)
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func transform(_ input: ChooseMapViewModel.Input) -> ChooseMapViewModel.Output {
        updateMapStyle <~ input.didSelectIndexPath.map { MapStyle(rawValue: $0.row) ?? self.useCases.settings.mapStyle.value }
        handlers.didSelectMapStyle <~ input.didSelectIndexPath.mapToVoid()
        return Output(sectionViewModels: .init(value: sectionsViewModels))
    }
    
    private var sectionsViewModels: SectionsViewModels {
        return [
            .init(cells: MapStyle.allCases.map { ChooseMapStyleCellViewModel(title: $0.title, color: $0.color) })
        ]
    }
    
}
