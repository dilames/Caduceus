//
//  SearchUserUseCase.swift
//  Domain
//
//  Created by Andrew Chersky  on 6/1/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol SearchUsersUseCase {
    func search(by input: String) -> SignalProducer<[User], AnyError>
}

public protocol HasSearchUsersUseCase {
    var searchUsers: SearchUsersUseCase { get }
}
