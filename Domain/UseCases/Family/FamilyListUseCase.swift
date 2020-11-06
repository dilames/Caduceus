//
//  FamilyListUseCase.swift
//  Domain
//
//  Created by Andrew Chersky  on 5/31/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol FamilyListUseCase {
    func fetchFamilyMembers() -> SignalProducer<[Patient], AnyError>
}

public protocol HasFamilyListUseCase {
    var familyList: FamilyListUseCase { get }
}
