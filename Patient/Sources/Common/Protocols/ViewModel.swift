//
//  ViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Foundation

public protocol ViewModel {
    associatedtype Input = Void
    associatedtype Output = Void
    
    func transform(_ input: Input) -> Output
}

public extension ViewModel where Input == Void, Output == Void {
    func transform(_ input: Input) -> Output {}
}

public extension ViewModel where Input == Void {
    func transform() -> Output {
        return transform(())
    }
}
