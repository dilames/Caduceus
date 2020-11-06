//
//  NewsSectionViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/6/18.
//

import Foundation
import ReactiveSwift
import Result
import Extensions

final class NewsSectionViewModel: ViewModel, Equatable {
    
    let dateString: MutableProperty<String>
    let weekdayString: MutableProperty<String>
    
    init(date: Date) {
        let dateString = DateFormatter.dayNumberAndName.string(from: date)
        let isToday = Calendar.current.isDateInToday(date)
        let weekdayString = isToday ? R.string.localizable.today() : DateFormatter.weekday.string(from: date)
        self.dateString = .init(dateString.uppercased())
        self.weekdayString = .init(weekdayString.capitalized)
    }
    
    public static func==(lhs: NewsSectionViewModel, rhs: NewsSectionViewModel) -> Bool {
        return lhs === rhs
    }
}
