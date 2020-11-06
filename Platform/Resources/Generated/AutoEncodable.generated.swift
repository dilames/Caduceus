// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
import RealmSwift

// Generated. Do not edit.

extension RMAddress {
    func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(koatuu, forKey: .koatuu)
        try container.encode(region, forKey: .region)
        try container.encode(subregion, forKey: .subregion)
        try container.encode(settlementType, forKey: .settlementType)
        try container.encode(streetType, forKey: .streetType)
        try container.encode(streetName, forKey: .streetName)
        try container.encode(buildingNumber, forKey: .buildingNumber)
        try container.encode(apartmentNumber, forKey: .apartmentNumber)
        try container.encode(isActual, forKey: .isActual)
    }
}

extension RMDocument {
    func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(serial, forKey: .serial)
        try container.encode(stateDepartment, forKey: .stateDepartment)
        try container.encode(number, forKey: .number)
        try container.encodeDate(startDate, with: dateFormatter, forKey: .startDate)
        try container.encodeDate(endDate, with: dateFormatter, forKey: .endDate)
    }
}

extension RMProfile {
    func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeDate(birthDate, with: dateFormatter, forKey: .birthDate)
        try container.encode(documents, forKey: .documents)
        try container.encode(addresses, forKey: .addresses)
    }
}

extension RMSecret {
    func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(passphrase, forKey: .passphrase)
    }
}

extension RMUser {
    func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(patronymic, forKey: .patronymic)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(profile, forKey: .profile)
        try container.encodeIfPresent(secret, forKey: .secret)
    }
}
