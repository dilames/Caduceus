//
//  SectionViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import Foundation

class SectionViewModel<Section: ViewModel, Cell: ViewModel> {
    let section: Section
    var cells: [Cell]
    
    init(section: Section, cells: [Cell]) {
        self.section = section
        self.cells = cells
    }
}

extension SectionViewModel where Section == EmptySectionViewModel {
    convenience init(cells: [Cell]) {
        self.init(section: .init(), cells: cells)
    }
}
