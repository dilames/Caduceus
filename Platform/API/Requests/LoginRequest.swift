//
//  Login.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/13/18.
//

import Foundation
import Domain
import Moya

extension API.Request {
    enum Login: NetworkTargetType {
        case loginRequest(phone: String, password: String, type: PhoneConfirmationType)
        case loginConfirm(phone: String, password: String, otp: String)
        case refreshToken(String)
        
        var path: String {
            switch self {
            case .loginRequest:
                return "login_request/"
            case .loginConfirm:
                return "login_confirm/"
            case .refreshToken:
                return "login_refresh/"
            }
        }
        
        var method: Moya.Method {
            return .post
        }
        
        var parameters: [String : Any] {
            switch self {
            case .loginRequest(let phone, let password, let type):
                return [
                    "phone": phone,
                    "password": password,
                    "type": type == .call ? "call" : "sms"
                ]
            case .loginConfirm(let phone, let password, let otp):
                return [
                    "phone": phone,
                    "password": password,
                    "otp": otp,
                    "grant_type": "password"
                ]
            case .refreshToken(let refreshToken):
                return [
                    "refresh_token": refreshToken,
                    "grant_type": "refresh_token"
                ]
            }
        }
        
        var scopes: [Scope] {
            switch self {
            case .loginConfirm:
                return [.person]
            default: return []
            }
        }
        
        var needsToAddAppKeys: Bool {
            return true
        }
    }
}
