//
//  CurrentUserUseCase.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/24/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol CurrentUserUseCase {
    var currentUser: Property<CurrentUser> { get }
}

public protocol HasCurrentUserUseCase {
    var currentUser: CurrentUserUseCase { get }
}
