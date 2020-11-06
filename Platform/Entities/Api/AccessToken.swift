//
//  AccessToken.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import Extensions

final class AccessToken: Codable {

    let tokenString: String
    let refreshTokenString: String
    private let accessTokenExpirationDate: Date
    private let refreshTokenExpirationDate: Date
    
    enum CodingKeys: String, CodingKey {
        case tokenString = "access_token"
        case refreshTokenString = "refresh_token"
        case accessTokenExpirationDate = "access_token_expiration_date"
        case refreshTokenExpirationDate = "refresh_token_expiration_date"
    }
    
    var isValid: Bool {
        return refreshTokenExpirationDate > Date()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tokenString = try container.decode(String.self, forKey: .tokenString)
        refreshTokenString = try container.decode(String.self, forKey: .refreshTokenString)
        accessTokenExpirationDate = try container.decodeDate(.server, forKey: .accessTokenExpirationDate)
        refreshTokenExpirationDate = try container.decodeDate(.server, forKey: .refreshTokenExpirationDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tokenString, forKey: .tokenString)
        try container.encode(refreshTokenString, forKey: .refreshTokenString)
        try container.encodeDate(accessTokenExpirationDate, with: .server, forKey: .accessTokenExpirationDate)
        try container.encodeDate(refreshTokenExpirationDate, with: .server, forKey: .refreshTokenExpirationDate)
    }
}
