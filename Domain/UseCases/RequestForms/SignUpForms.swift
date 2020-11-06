//
//  SignUpForms.swift
//  Domain
//
//  Created by Andrew Chersky  on 3/6/18.
//

import Foundation

public struct SignUpSecondStepForm: AutoTupleInitializable {
    public let phoneNumber: String
    public let smsCode: String
    public let password: String
    public let confirmPassword: String

// sourcery:inline:auto:SignUpSecondStepForm.AutoPublicStruct
// DO NOT EDIT
    public init(
		phoneNumber: String,
        smsCode: String,
        password: String,
        confirmPassword: String)
	{
        self.phoneNumber = phoneNumber
        self.smsCode = smsCode
        self.password = password
        self.confirmPassword = confirmPassword
    }
// sourcery:end
}
