//
//  RMAddress.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import RealmSwift
import Domain

@objcMembers final class RMAddress: Object, AutoCodable {
    dynamic var id: String = ""
    dynamic var type: String = ""
    dynamic var koatuu: String = ""
    dynamic var region: String = ""
    dynamic var subregion: String = ""
    dynamic var settlementType: String = ""
    dynamic var streetType: String = ""
    dynamic var streetName: String = ""
    dynamic var buildingNumber: String = ""
    dynamic var apartmentNumber: String = ""
    dynamic var isActual: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case koatuu
        case region
        case subregion
        case settlementType = "settlement_type"
        case streetType = "street_type"
        case streetName = "street_name"
        case buildingNumber = "building_number"
        case apartmentNumber = "apartment_number"
        case isActual = "is_actual"
    }
}

// MARK: - DomainConvertible
extension RMAddress {
    var asDomain: Address {
        return Address(
            id: id,
            koatuu: koatuu,
            region: region,
            subregion: subregion,
            settlementType: settlementType,
            streetType: streetType,
            streetName: streetName,
            buildingNumber: buildingNumber,
            apartmentNumber: apartmentNumber,
            isActual: isActual
        )
    }
}
