//
//  Patient.swift
//  Domain
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation

public struct User {
    public let id: String
    public let email: String?
    public let firstName: String?
    public let lastName: String?
    public let patronymic: String?
    public let phone: String?
    public let profile: Profile?
    public let secret: Secret?

// sourcery:inline:auto:User.AutoPublicStruct
// DO NOT EDIT
    public init(
		id: String,
        email: String?,
        firstName: String?,
        lastName: String?,
        patronymic: String?,
        phone: String?,
        profile: Profile?,
        secret: Secret?)
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
