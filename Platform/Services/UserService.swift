//
//  UserService.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/13/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result
import Domain

final class UserService: CurrentUserUseCase, SessionUseCase {

    private let network: Network
    
    // MARK: - CurrentUserUseCase
    
    internal let _currentUser: MutableProperty<CurrentUser> = .init(.guest)
    private(set) lazy var currentUser: Property<CurrentUser> = .init(_currentUser)
    
    // MARK: - SessionUseCase
    
    let isSessionAlive: Bool
    
    // MARK: - Lifecycle
    
    init(network: Network) {
        self.network = network
        let session = UserSession.fetch()
        isSessionAlive = session?.accessToken.isValid ?? false
        setCurrentUser(using: session)
    }
    
    private func setCurrentUser(using session: UserSession?) {
        if let session = session {
            // Or as patient
            let user = session.user.asUser
            _currentUser.value = .user(user)
        } else {
            _currentUser.value = .guest
        }
    }
}
