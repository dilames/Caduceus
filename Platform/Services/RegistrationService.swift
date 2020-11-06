//
//  RegistrationService.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/13/18.
//

import Foundation
import ReactiveSwift
import Result
import Moya
import Domain

final class RegistrationService {
   
    private let network: Network
    private let currentUser: MutableProperty<CurrentUser>
    private let accessToken: MutableProperty<AccessToken?>
    private let userRepository: RealmRepository<RMUser>
    
    private var registrationProvider: MoyaProvider<API.Request.Registration> {
        return network.provider()
    }
    
    private var userProvider: MoyaProvider<API.Request.User> {
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
}

// MARK: - SignUpUseCase
extension RegistrationService: SignUpUseCase {
    func requestSmsCode(for phoneNumber: String) -> SignalProducer<Void, AnyError> {
        return requestOtpCode(for: phoneNumber, type: .message)
    }
    
    func requestCall(for phoneNumber: String) -> SignalProducer<Void, AnyError> {
        return requestOtpCode(for: phoneNumber, type: .call)
    }
    
    func takeSecondStep(form: SignUpSecondStepForm) -> SignalProducer<Void, AnyError> {
        return registrationProvider
            .reactive
            .fetchRequest(.secondStep(phone: form.phoneNumber,
                                      password: form.password,
                                      otp: form.smsCode))
            .flatMap(.concat, saveSession)
        	.flatMap(.concat, updateCurrentSession)
    }
    
    func takeThirdStep(form: UpdatePersonForm) -> SignalProducer<Void, AnyError> {
        let currentIdProducer = userRepository.reactive
            .queryFirst()
            .map {$0?.id ?? ""}
        return currentIdProducer
            .flatMap(.concat, {
                self.userProvider.reactive
                    .fetchRequest(.updateInfo(form, ofUserWithId: $0))
                    .flatMap(.concat, self.saveUser)
                    .flatMap(.concat, self.setCurrentUser)
            })
            .mapToVoid()
    }
    
    func takeFourthStep(form: UpdateSecretForm) -> SignalProducer<Void, AnyError> {
        let currentIdProducer = userRepository.reactive
            .queryFirst()
            .map {$0?.id ?? ""}
        return currentIdProducer
            .flatMap(.concat, {
                self.userProvider.reactive
                    .fetchRequest(.updateSecret(form, ofUserWithId: $0))
                    .flatMap(.concat, self.saveUser)
                    .flatMap(.concat, self.setCurrentUser)
            })
            .mapToVoid()
    }
}

// MARK: - SecretQuestionsUseCase
extension RegistrationService: SecretQuestionsUseCase {
    func fetch() -> SignalProducer<[String], AnyError> {
        return SignalProducer { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                observer.send(value: ["Вопрос первый", "Вопрос второй", "Вопрос третий",
                                      "Вопрос первый", "Вопрос второй", "Вопрос третий",
                                      "Вопрос первый", "Вопрос второй", "Вопрос третий",
                                      "Вопрос первый", "Вопрос второй", "Вопрос третий",
                                      "Вопрос первый", "Вопрос второй", "Вопрос третий"])
                observer.sendCompleted()
            })
        }
    }
}

// MARK: - Private
extension RegistrationService {
    private func requestOtpCode(for phoneNumber: String, type: PhoneConfirmationType) -> SignalProducer<Void, AnyError> {
        return registrationProvider
            .reactive
            .successRequest(.firstStep(phone: phoneNumber, type: type))
    }
    
    private func saveSession(_ response: API.Response.Auth) -> SignalProducer<UserSession, AnyError> {
        let session = UserSession(user: response.user, accessToken: response.accessToken)
        return session.reactive.save()
            .map { session.user }
            .flatMap(.concat, userRepository.reactive.save)
            .map { session }
    }
    
    private func saveUser(_ userDataResponse: ApiResponse<RMUser>) -> SignalProducer<User, AnyError> {
        let user = userDataResponse.data
        return userRepository.reactive
            .save(user)
            .map { user.asUser }
    }
    
    private func updateCurrentSession(_ session: UserSession) -> SignalProducer<Void, AnyError> {
        currentUser.value = .user(session.user.asUser)
        accessToken.value = session.accessToken
        return .executingEmpty
    }
    
    private func setCurrentUser(_ user: User) -> SignalProducer<Void, AnyError> {
        currentUser.value = .user(user)
        return .executingEmpty
    }
}
