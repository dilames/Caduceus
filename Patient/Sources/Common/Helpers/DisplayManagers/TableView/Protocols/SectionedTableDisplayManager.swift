//
//  SectionedTableDisplayManager.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import UIKit

protocol SectionedTableDisplayManager: UITableViewDataSource, UITableViewDelegate {
    associatedtype SectionViewModelType: EquatableViewModel
    associatedtype CellViewModelType: EquatableViewModel
    
    typealias SectionViewModels = [SectionViewModel<SectionViewModelType, CellViewModelType>]
    
    var sectionsViewModels: SectionViewModels { get set }
}
