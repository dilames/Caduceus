// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
import RealmSwift

// Generated. Do not edit.

extension RMAddress {
    convenience init(from decoder: Decoder) throws {
		self.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        koatuu = try container.decode(String.self, forKey: .koatuu)
        region = try container.decode(String.self, forKey: .region)
        subregion = try container.decode(String.self, forKey: .subregion)
        settlementType = try container.decode(String.self, forKey: .settlementType)
        streetType = try container.decode(String.self, forKey: .streetType)
        streetName = try container.decode(String.self, forKey: .streetName)
        buildingNumber = try container.decode(String.self, forKey: .buildingNumber)
        apartmentNumber = try container.decode(String.self, forKey: .apartmentNumber)
        isActual = try container.decode(Bool.self, forKey: .isActual)
    }
}

extension RMDocument {
    convenience init(from decoder: Decoder) throws {
		self.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        serial = try container.decode(String.self, forKey: .serial)
        stateDepartment = try container.decode(String.self, forKey: .stateDepartment)
        number = try container.decode(String.self, forKey: .number)
        startDate = try container.decodeDate(dateFormatter, forKey: .startDate)
        endDate = try container.decodeDate(dateFormatter, forKey: .endDate)
    }
}

extension RMProfile {
    convenience init(from decoder: Decoder) throws {
		self.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
        birthDate = try container.decodeDate(dateFormatter, forKey: .birthDate)
        documents = try container.decode(List<RMDocument>.self, forKey: .documents)
        addresses = try container.decode(List<RMAddress>.self, forKey: .addresses)
    }
}

extension RMSecret {
    convenience init(from decoder: Decoder) throws {
		self.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
        passphrase = try container.decode(String.self, forKey: .passphrase)
    }
}

extension RMUser {
    convenience init(from decoder: Decoder) throws {
		self.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        patronymic = try container.decodeIfPresent(String.self, forKey: .patronymic)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        profile = try container.decodeIfPresent(RMProfile.self, forKey: .profile)
        secret = try container.decodeIfPresent(RMSecret.self, forKey: .secret)
    }
}
