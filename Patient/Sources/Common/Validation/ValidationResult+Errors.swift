//
//  ValidationRuleSet+Errors.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/26/18.
//

import enum Validator.ValidationResult

extension ValidationResult {
    var errors: [Error] {
        switch self {
        case .valid:
            return []
        case .invalid(let errors):
            return errors
        }
    }
}
