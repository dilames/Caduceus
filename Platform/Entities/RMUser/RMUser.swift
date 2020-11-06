//
//  RMUser.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/16/18.
//

import Foundation
import RealmSwift
import Domain

@objcMembers final class RMUser: Object, AutoCodable {
    dynamic var id: String = ""
    dynamic var email: String?
    dynamic var firstName: String?
    dynamic var lastName: String?
    dynamic var patronymic: String?
    dynamic var phone: String?
    dynamic var profile: RMProfile?
    dynamic var secret: RMSecret?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case patronymic = "middle_name"
        case phone
        case profile
        case secret
    }
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
    
    var isPatient: Bool {
        return false
    }
}

// MARK: - DomainConvertible
extension RMUser {
    var asUser: User {
        return User(
            id: id,
            email: email,
            firstName: firstName,
            lastName: lastName,
            patronymic: patronymic,
            phone: phone,
            profile: profile?.asDomain,
            secret: secret?.asDomain)
    }
    
    convenience init(user: User) {
        self.init()
        self.id = user.id
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.patronymic = user.patronymic
        self.phone = user.phone
        self.profile = RMProfile()
        self.secret = RMSecret()
    }
}
