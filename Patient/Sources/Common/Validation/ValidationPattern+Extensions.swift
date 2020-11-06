//
//  ValidationPattern+Extensions.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/27/18.
//

import protocol Validator.ValidationPattern

enum PasswordValidationPattern: ValidationPattern {
    case simple
    case standart
    
    var pattern: String {
        switch self {
        case .simple:
            return "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        case .standart:
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        }
    }
}
