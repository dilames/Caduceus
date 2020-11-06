//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Foundation

public typealias UseCases =
    HasAuthUseCase
    & HasSignUpUseCase
    & HasCurrentUserUseCase
    & HasSessionUseCase
    & HasSecretQuestionsUseCase
    & HasLocationUseCase
    & HasSettingsUseCase
    & HasFamilyListUseCase
    & HasSearchUsersUseCase

public protocol UseCaseProvider: UseCases {}
