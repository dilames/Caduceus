//
//  RMUserProfile.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import RealmSwift
import Domain

@objcMembers final class RMProfile: Object, AutoCodable {
    dynamic var birthDate: Date = Date()
    dynamic var documents: List<RMDocument> = List()
    dynamic var addresses: List<RMAddress> = List()
    
    enum CodingKeys: String, CodingKey {
        case birthDate = "birth_date"
        case documents
        case addresses
    }
}

// MARK: - DomainConvertible
extension RMProfile {
    var asDomain: Profile {
        return Profile(
            birthDate: birthDate,
            documents: documents.map {$0.asDomain},
            addresses: addresses.map {$0.asDomain}
        )
    }
}
