//
//  NewsViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/3/18.
//

import Domain
import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result
import Dwifft

final class NewsViewModel: ViewModel {
    
    struct Input {
        let didTapItem: Signal<IndexPath, Never>
    }
    
    struct Output {
        let news: Property<SectionedValues<DataSourceSection<NewsSectionViewModel>, NewsCellViewModel>>
    }
    
    struct Handlers {
        let selectNewsItem: Action<NewsCellViewModel, Void, Never>
    }
    
    private let useCases: UseCaseProvider
    private let handlers: Handlers
    
    init(useCases: UseCaseProvider, handlers: Handlers) {
        self.useCases = useCases
        self.handlers = handlers
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func transform(_ input: Input) -> NewsViewModel.Output {
        let firstSection = DataSourceSection(headerViewModel: NewsSectionViewModel(date: Date()))
        let secondSection = DataSourceSection(headerViewModel: NewsSectionViewModel(date: Date(timeIntervalSinceNow: -100000)))
        
        let firstNews = NewsCellViewModel(title: "ЗАГОЛОВОК")
        let secondNews = NewsCellViewModel(title: "ЗАГОЛОВОК")
        let thirdNews = NewsCellViewModel(title: "ЗАГОЛОВОК")
        
        let firstArray = [firstNews, secondNews]
        let secondArray = [thirdNews, thirdNews]
        
        let sectionedValue = SectionedValues([(firstSection, firstArray), (secondSection, secondArray)])
        
        let mutableNews = MutableProperty(sectionedValue)
        let news = Property(mutableNews)
        
        handlers.selectNewsItem <~ input.didTapItem.map { news.value.sectionsAndValues[$0.section].1[$0.item] }
        
        return Output(news: news)
    }
}
