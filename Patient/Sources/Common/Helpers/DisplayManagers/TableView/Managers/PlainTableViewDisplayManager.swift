//
//  PlainTableViewDataSource.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/6/18.
//

import UIKit
import ReactiveSwift
import Result

private typealias Parent<T: EquatableViewModel> = TableViewDisplayManager<EmptySectionViewModel, T>

final class PlainTableViewDisplayManager<CellVM: EquatableViewModel>: TableViewDisplayManager<EmptySectionViewModel, CellVM>, SequenceDisplayManager {
    
    var values: [CellVM] {
        get {
        	return sectionsViewModels.first?.cells ?? []
        } set {
            if let sectionViewModel = sectionsViewModels.first {
                sectionsViewModels = [SectionViewModel(section: sectionViewModel.section,
                                                      cells: newValue)]
            } else {
                sectionsViewModels = [SectionViewModel(cells: newValue)]
            }
        }
    }
}
