//
//  DataSourceSection.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/4/18.
//

import Foundation

struct DataSourceSection<HeaderViewModel: Equatable>: Equatable {
    let headerViewModel: HeaderViewModel?
    
    public static func==(lhs: DataSourceSection, rhs: DataSourceSection) -> Bool {
        return lhs.headerViewModel == rhs.headerViewModel
    }
}

final class EmptySectionViewModel: ViewModel, Equatable {
    static func==(lhs: EmptySectionViewModel, rhs: EmptySectionViewModel) -> Bool {
        return lhs === rhs
    }
}
