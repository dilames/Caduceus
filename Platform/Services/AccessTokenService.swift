//
//  AccessTokenService.swift
//  Platform
//
//  Created by Andrew Chersky  on 5/2/18.
//

import Foundation
import Domain
import ReactiveSwift
import Moya
import Result

final class AccessTokenService: AccessTokenProvider {
    
    let _accessToken: MutableProperty<AccessToken?>
    private(set) lazy var accessToken: Property<AccessToken?> = .init(_accessToken)
    private let currentUser: MutableProperty<CurrentUser>
    
    private let network: Network
    private let userRepository: RealmRepository<RMUser>
    
    private var provider: MoyaProvider<API.Request.Login> {
        return network.provider()
    }
    
    init(network: Network, currentUser: MutableProperty<CurrentUser>) {
        self.network = network
        self.currentUser = currentUser
        _accessToken = .init(UserSession.fetch()?.accessToken)
        userRepository = RealmRepository()
    }
    
    func refreshToken(else error: Error) -> SignalProducer<Void, AnyError> {
        guard let refreshToken = accessToken.value?.refreshTokenString else {
            return .init(error: .init(error))
        }
        return provider.reactive
            .fetchRequest(.refreshToken(refreshToken))
            .flatMap(.concat, handleResponse)        
    }
    
    private func handleResponse(_ response: API.Response.Auth) -> SignalProducer<Void, AnyError> {
		let session = UserSession(user: response.user, accessToken: response.accessToken)
        _accessToken.value = response.accessToken
        currentUser.value = .user(response.user.asUser)
        return session.reactive
            .save()
            .map { session.user }
        	.flatMap(.concat, userRepository.reactive.save)
    }
}
