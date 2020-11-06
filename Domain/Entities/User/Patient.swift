//
//  User.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Foundation

public struct Patient {
    public let id: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let patronymic: String?
    public let phone: String
    public let profile: Profile
    public let secret: Secret

// sourcery:inline:auto:Patient.AutoPublicStruct
// DO NOT EDIT
    public init(
		id: String,
        email: String,
        firstName: String,
        lastName: String,
        patronymic: String?,
        phone: String,
        profile: Profile,
        secret: Secret)
	{
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.patronymic = patronymic
        self.phone = phone
        self.profile = profile
        self.secret = secret
    }
// sourcery:end
}

extension Patient {
    public var asUser: User {
        return User(
            id: id,
            email: email,
            firstName: firstName,
            lastName: lastName,
            patronymic: patronymic,
            phone: phone,
            profile: profile,
            secret: secret)
    }
}
