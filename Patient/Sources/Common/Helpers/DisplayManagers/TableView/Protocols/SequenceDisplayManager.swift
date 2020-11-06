//
//  EmptySectionDisplayManager.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/18/18.
//

import Foundation

protocol SequenceDisplayManager: NSObjectProtocol {
    associatedtype CellViewModelType
    
    var values: [CellViewModelType] { get set }
}
