//
//  ValidationRuleRequiredNotEmpty.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/26/18.
//

import Foundation
import Validator

public struct ValidationRuleRequiredNotEmpty: ValidationRule {
    
    public let error: ValidationError
    
    public init(error: ValidationError) {
        self.error = error
    }
    
    public func validate(input: String?) -> Bool {
        return !(input ?? "").isEmpty
    }
}
