//
//  RMUserSecret.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import RealmSwift
import Domain

@objcMembers final class RMSecret: Object, AutoCodable {
    dynamic var passphrase: String = ""
    
    enum CodingKeys: String, CodingKey {
        case passphrase
    }
}

// MARK: - DomainConvertible
extension RMSecret {
    var asDomain: Secret {
        return Secret(passphrase: passphrase)
    }
}
