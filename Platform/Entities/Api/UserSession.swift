//
//  Session.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import RealmSwift
import KeychainAccess

final class UserSession: Codable {

    let user: RMUser
    let accessToken: AccessToken
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken
    }
    
    init(user: RMUser, accessToken: AccessToken) {
        self.user = user
        self.accessToken = accessToken
    }
    
    static var keychain: Keychain {
        return Keychain(service: Key.service)
    }
    
    func save() throws {
        let data = try JSONEncoder().encode(self)
        UserSession.keychain[data: Key.session] = data
    }
    
    func invalidate() throws {
        try UserSession.keychain.remove(Key.session)
    }
    
    static func fetch() -> UserSession? {
        do {
            guard let data = try UserSession.keychain.getData(Key.session) else { return nil }
            return try JSONDecoder().decode(UserSession.self, from: data)
        } catch {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userId = try container.decode(String.self, forKey: .user)
        let realm = try Realm()
        guard let user = realm.object(ofType: RMUser.self, forPrimaryKey: userId) else {
            throw DecodingError.valueNotFound(
                RMUser.self,
                DecodingError.Context(codingPath: container.codingPath, debugDescription: "User not found"))
        }
        self.user = user
        accessToken = try container.decode(AccessToken.self, forKey: .accessToken)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user.id, forKey: .user)
        try container.encode(accessToken, forKey: .accessToken)
    }
}

private enum Key {
    static let session: String = "session"
    static let service: String = "com.iti.caduceus"
}
