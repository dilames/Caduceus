//
//  Public.swift
//  Platform
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Domain
import Foundation

public protocol PlatformEnvironment {
    var baseURL: URL { get }
}

public struct Platform: UseCaseProvider {
    
    private let environment: PlatformEnvironment
    private let network = Network()
    
    public let auth: AuthUseCase
    public let signUp: SignUpUseCase
    public let secretQuestions: SecretQuestionsUseCase
    public let currentUser: CurrentUserUseCase
    public let session: SessionUseCase
    public let location: LocationUseCase
    public let settings: SettingsUseCase
    public let familyList: FamilyListUseCase
    public let searchUsers: SearchUsersUseCase
    
    static var baseURL: URL?
    
    public init(environment: PlatformEnvironment) {
    	self.environment = environment
        Platform.baseURL = environment.baseURL
        
        let userService = UserService(network: network)
        let accessTokenProvider = AccessTokenService(network: network, currentUser: userService._currentUser)
        let loginService = LoginService(network: network,
                                        currentUser: userService._currentUser,
                                        accessToken: accessTokenProvider._accessToken)
        let registrationService = RegistrationService(network: network,
                                                      currentUser: userService._currentUser,
                                                      accessToken: accessTokenProvider._accessToken)
        let locationService = LocationService()
        let settingsService = SettingsService()
        let familyService = FamilyService(network: network)
        
        network.accessTokenProvider = accessTokenProvider
        currentUser = userService
        session = userService
        auth = loginService
        signUp = registrationService
        secretQuestions = registrationService
        location = locationService
        settings = settingsService
        familyList = familyService
        searchUsers = familyService
    }
}
