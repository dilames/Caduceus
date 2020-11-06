//
//  Validation.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Foundation
import Validator
import PhoneNumberKit

extension ValidationRuleSet where InputType == String {
    static func phoneNumber(errorMessage: String = "") -> ValidationRuleSet<InputType> {
        var rules: ValidationRuleSet<String> = .init()
        let error = ValidationPatientError(message: errorMessage)
        let requiredError = ValidationPatientError(message: "Field is required")
        let pattern = "^[+]{1}[0-9]{12}$"
        let patternRule = ValidationRulePattern(pattern: pattern, error: error)
        let requiredRule = ValidationRuleRequiredNotEmpty(error: requiredError)
        rules.add(rule: requiredRule)
        rules.add(rule: patternRule)
        return rules
    }
    
    static func password(errorMessage: String = "") -> ValidationRuleSet<InputType> {
        var rules: ValidationRuleSet<String> = .init()
        let error = ValidationPatientError(message: errorMessage)
        let requiredError = ValidationPatientError(message: "Field is required")
        let patternRule = ValidationRulePattern(pattern: PasswordValidationPattern.simple, error: error)
        let requiredRule = ValidationRuleRequiredNotEmpty(error: requiredError)
        rules.add(rule: patternRule)
        rules.add(rule: requiredRule)
        return rules
    }
    
    static var name: ValidationRuleSet<InputType> {
        var rules: ValidationRuleSet<String> = .init()
        let requiredError = ValidationPatientError(message: "Requred change later")
        let required = ValidationRuleRequiredNotEmpty(error: requiredError)
        let maxSizeError = ValidationPatientError(message: "Max size change later")
		let maxSize = ValidationRuleLength(min: 1, max: 30, lengthType: .utf16, error: maxSizeError)
        rules.add(rule: required)
        rules.add(rule: maxSize)
        return rules
    }
    
    static func email(errorMessage: String) -> ValidationRuleSet<InputType> {
        let error = ValidationPatientError(message: errorMessage)
        let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: error)
        return ValidationRuleSet(rules: [rule])
    }
    
    static var required: ValidationRuleSet<InputType> {
        let error = ValidationPatientError(message: "Field is required")
        let rule = ValidationRuleRequiredNotEmpty(error: error)
        return ValidationRuleSet(rules: [rule])
    }
}

extension ValidationRuleSet {
    static func comparison(_ comparisonBlock: @escaping (InputType) -> Bool,
                           errorMessage: String = "")  -> ValidationRuleSet<InputType> {
        let error = ValidationPatientError(message: errorMessage)
        let rule = ValidationRuleCondition<InputType>(error: error) {
            guard let input = $0 else { return false }
            return comparisonBlock(input)
        }
        return ValidationRuleSet(rules: [rule])
    }
}
