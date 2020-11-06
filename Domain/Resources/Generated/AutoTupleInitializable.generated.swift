// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable large_tuple

import Foundation

public extension SignUpSecondStepForm {
	public typealias Arguments = (String, String, String, String)
    public init(_ arguments: Arguments) {
        phoneNumber = arguments.0
        smsCode = arguments.1
        password = arguments.2
        confirmPassword = arguments.3
    }
}

public extension UpdatePersonForm {
	public typealias Arguments = (String?, String?, String?, Gender?, String?, Date?)
    public init(_ arguments: Arguments) {
        firstName = arguments.0
        lastName = arguments.1
        patronymic = arguments.2
        gender = arguments.3
        email = arguments.4
        birthDate = arguments.5
    }
}

public extension UpdateSecretForm {
	public typealias Arguments = (String, String, String, String, String, String)
    public init(_ arguments: Arguments) {
        firstQuestion = arguments.0
        firstAnswer = arguments.1
        secondQuestion = arguments.2
        secondAnswer = arguments.3
        thirdQuestion = arguments.4
        thirdAnswer = arguments.5
    }
}
