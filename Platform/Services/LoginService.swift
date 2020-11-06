//
//  LoginService.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/13/18.
//

import Foundation
import ReactiveSwift
import Result
import Moya
import Domain

final class LoginService: AuthUseCase {
    
    // MARK: - Properties
    
    private let network: Network
    private let currentUser: MutableProperty<CurrentUser>
    private let accessToken: MutableProperty<AccessToken?>
    private let userRepository: RealmRepository<RMUser>
    
    private var loginProvider: MoyaProvider<API.Request.Login> {
        return network.provider()
    }
    
    init(network: Network,
         currentUser: MutableProperty<CurrentUser>,
         accessToken: MutableProperty<AccessToken?>) {
        self.network = network
        self.currentUser = currentUser
        self.accessToken = accessToken
        userRepository = .init()
    }
    
    // MARK: - AuthUseCase

    func requestSmsCode(to phoneNumber: String, password: String) -> SignalProducer<Void, AnyError> {
        return requestOtpCode(for: phoneNumber, password: password, type: .message)
    }
    
    func requestCall(for phoneNumber: String, password: String) -> SignalProducer<Void, AnyError> {
        return requestOtpCode(for: phoneNumber, password: password, type: .call)
    }
    
    func send(smsCode: String, password: String, phone: String) -> SignalProducer<Void, AnyError> {
        return loginProvider
            .reactive
            .fetchRequest(.loginConfirm(phone: phone, password: password, otp: smsCode))
            .flatMap(.concat, saveSession)
        	.flatMap(.concat, updateCurrentSession)
    }
    
    // MARK: - Private
    
    private func requestOtpCode(
        for phoneNumber: String,
        password: String,
        type: PhoneConfirmationType) -> SignalProducer<Void, AnyError>
    {
        return loginProvider
            .reactive
            .successRequest(.loginRequest(phone: phoneNumber, password: password, type: type))
    }
    
    private func saveSession(_ response: API.Response.Auth) -> SignalProducer<UserSession, AnyError> {
        let session = UserSession(user: response.user, accessToken: response.accessToken)
        return session.reactive.save()
            .map { session.user }
            .flatMap(.concat, userRepository.reactive.save)
            .map { session }
    }
    
    private func updateCurrentSession(_ session: UserSession) -> SignalProducer<Void, AnyError> {
        currentUser.value = .user(session.user.asUser)
        accessToken.value = session.accessToken
        return .executingEmpty
    }
}
