//
//  CurrentUser.swift
//  Domain
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation

public enum CurrentUser {
    case guest
    case user(User)
    case patient(Patient)
}

extension CurrentUser {
    public var user: User? {
        switch self {
        case .user(let user):
            return user
        case .patient(let patient):
            return patient.asUser
        case .guest:
            return nil
        }
    }
}
