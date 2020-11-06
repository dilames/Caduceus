//
//  AuthResponse.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/20/18.
//

import Foundation

extension API.Response {
    struct Auth: Decodable {
        let user: RMUser
        let accessToken: AccessToken
        
        enum CodingKeys: String, CodingKey {
            case user = "data"
            case accessToken = "session"
        }
    }
}
