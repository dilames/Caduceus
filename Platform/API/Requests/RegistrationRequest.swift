//
//  Registration.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import Domain
import Moya

extension API.Request {
    enum Registration: NetworkTargetType {
        case firstStep(phone: String, type: PhoneConfirmationType)
        case secondStep(phone: String, password: String, otp: String)
        
        var path: String {
            switch self {
            case .firstStep:
                return "checkphone_request/"
            case .secondStep:
                return "registration_request/"
            }
        }
        
        var method: Moya.Method {
            return .post
        }
        
        var parameters: [String : Any] {
            switch self {
            case .firstStep(let phone, let type):
                return [
                    "phone": phone,
                    "type": type == .message ? "sms" : "call"
                ]
            case .secondStep(let phone, let password, let otp):
                return [
                    "phone": phone,
                    "password": password,
                    "otp": otp,
                    "grant_type": "password"
                ]
            }
        }
        
        var needsToAddAppKeys: Bool {
            return true
        }
        
        var scopes: [Scope] {
            switch self {
            case .secondStep:
                return [.person]
            default: return []
            }
        }
    }
}
