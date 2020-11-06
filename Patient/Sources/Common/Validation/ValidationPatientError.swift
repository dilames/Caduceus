//
//  ValidationError.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Foundation
import Validator

struct ValidationPatientError: LocalizedError, ValidationError {
    
    let message: String
    
    var localizedDescription: String {
        return message
    }
    
    var errorDescription: String? {
        return message
    }
}
