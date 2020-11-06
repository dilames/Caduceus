//
//  SideMenuViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

final class SideMenuViewModel: ViewModel {

    typealias SectionsViewModels = [SectionViewModel<EmptySectionViewModel, SideMenuCellViewModel>]
    
    struct Input {
        let didSelectIndexPath: Signal<IndexPath, Never>
    }
    
    struct Output {
        let sectionsViewModels: Property<SectionsViewModels>
    }
    
    struct Handlers {
        let didSelectItem: Action<SideMenuCellViewModel, Void, Never>
    }
    
    private let handlers: Handlers
    
    init(handlers: Handlers) {
        self.handlers = handlers
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
	
    func transform(_ input: Input) -> Output {
        handlers.didSelectItem <~ input.didSelectIndexPath.map {
            self.sectionsViewModels[$0.section].cells[$0.row]
        }
        return Output(sectionsViewModels: .init(value: sectionsViewModels))
    }
    
    private var sectionsViewModels: SectionsViewModels {
        let testURL = URL(string: "https://i.pinimg.com/736x/96/c1/77/96c177a8fd610c76394dd932aa6369a8--man-bun-undercut-men-haircut-undercut.jpg")
        return [
            .init(cells: [.profile(.init(username: "Username", userImageUrl: testURL))]),
            .init(cells: [.family(.init(text: "Family", icon: #imageLiteral(resourceName: "family-icon")))]),
            .init(cells: [.settings(.init(text: "Settings", icon: #imageLiteral(resourceName: "settings-icon")))])
            
        ]
    }
}
