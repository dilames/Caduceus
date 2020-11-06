//
//  UserForms.swift
//  Domain
//
//  Created by Andrew Chersky  on 5/11/18.
//

import Foundation

public struct UpdatePersonForm: AutoTupleInitializable {
    public let firstName: String?
    public let lastName: String?
    public let patronymic: String?
    public let gender: Gender?
    public let email: String?
    public let birthDate: Date?
    
// sourcery:inline:auto:UpdatePersonForm.AutoPublicStruct
// DO NOT EDIT
    public init(
		firstName: String?,
        lastName: String?,
        patronymic: String?,
        gender: Gender?,
        email: String?,
        birthDate: Date?)
	{
        self.firstName = firstName
        self.lastName = lastName
        self.patronymic = patronymic
        self.gender = gender
        self.email = email
        self.birthDate = birthDate
    }
// sourcery:end
}

public struct UpdateSecretForm: AutoTupleInitializable {
    public let firstQuestion: String
    public let firstAnswer: String
    public let secondQuestion: String
    public let secondAnswer: String
    public let thirdQuestion: String
    public let thirdAnswer: String

// sourcery:inline:auto:UpdateSecretForm.AutoPublicStruct
// DO NOT EDIT
    public init(
		firstQuestion: String,
        firstAnswer: String,
        secondQuestion: String,
        secondAnswer: String,
        thirdQuestion: String,
        thirdAnswer: String)
	{
        self.firstQuestion = firstQuestion
        self.firstAnswer = firstAnswer
        self.secondQuestion = secondQuestion
        self.secondAnswer = secondAnswer
        self.thirdQuestion = thirdQuestion
        self.thirdAnswer = thirdAnswer
    }
// sourcery:end
}
