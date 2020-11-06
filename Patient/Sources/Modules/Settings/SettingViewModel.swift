//
//  SettingsViewModel.swift
//  Patient
//
//  Created by Andrew Chersky on 5/18/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result
import Domain

final class SettingsViewModel: ViewModel {
    
    typealias SectionsViewModels = [SectionViewModel<EmptySectionViewModel, SettingCellViewModel>]
    typealias UseCases = HasSettingsUseCase
    
    struct Input {
        let didSelectIndexPath: Signal<IndexPath, Never>
    }
    
    struct Output {
        let sectionViewModels: Property<SectionsViewModels>
    }
    
    struct Handlers {
        let didTapEditProfile: ActionHandler
        let didTapChooseMapStyle: ActionHandler
    }
    
    private let handlers: Handlers
    private let useCases: UseCases
    
    init(handlers: Handlers, useCases: UseCases) {
        self.handlers = handlers
        self.useCases = useCases
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func transform(_ input: SettingsViewModel.Input) -> SettingsViewModel.Output {
        handlers.didTapEditProfile <~ input.didSelectIndexPath
            .map { self.sectionsViewModels[$0.section].cells[$0.row] }
            .filter { if case .editProfile = $0 { return true } else { return false } }
            .mapToVoid()
        handlers.didTapChooseMapStyle <~ input.didSelectIndexPath
            .map { self.sectionsViewModels[$0.section].cells[$0.row] }
            .filter { if case .mapStyle = $0 { return true } else { return false } }
            .mapToVoid() 
        return Output(sectionViewModels: .init(value: sectionsViewModels))
    }
    
    private var sectionsViewModels: SectionsViewModels {
        let mapStyleCellViewModel = SelectionCellViewModel(title: R.string.localizable.chooseMapStyle(),
                                                           subtitle: useCases.settings.mapStyle.value.title)
        mapStyleCellViewModel.subtitle <~ useCases.settings.mapStyle.map { $0.title }
        return [
            .init(
                cells: [.editProfile(.init(title: R.string.localizable.editProfile())),
                        .mapStyle(mapStyleCellViewModel)])
        ]
    }
}
