//
//  UserAddress.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/22/18.
//

import Foundation

public struct Address {
    let id: String
//    let type: Int
    let koatuu: String
    let region: String
    let subregion: String
    let settlementType: String
    let streetType: String
    let streetName: String
    let buildingNumber: String
    let apartmentNumber: String
    let isActual: Bool

// sourcery:inline:auto:Address.AutoPublicStruct
// DO NOT EDIT
    public init(
		id: String,
        koatuu: String,
        region: String,
        subregion: String,
        settlementType: String,
        streetType: String,
        streetName: String,
        buildingNumber: String,
        apartmentNumber: String,
        isActual: Bool)
	{
        self.id = id
        self.koatuu = koatuu
        self.region = region
        self.subregion = subregion
        self.settlementType = settlementType
        self.streetType = streetType
        self.streetName = streetName
        self.buildingNumber = buildingNumber
        self.apartmentNumber = apartmentNumber
        self.isActual = isActual
    }
// sourcery:end
}
