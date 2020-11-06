//
//  Division.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/24/18.
//

import Foundation
import CoreLocation

public struct Division {
    let name: String
    let phone: String
    let email: String
    let type: String
    let coordinate: CLLocation
    let addresses: [Address]

// sourcery:inline:auto:Division.AutoPublicStruct
// DO NOT EDIT
    public init(
		name: String,
        phone: String,
        email: String,
        type: String,
        coordinate: CLLocation,
        addresses: [Address])
	{
        self.name = name
        self.phone = phone
        self.email = email
        self.type = type
        self.coordinate = coordinate
        self.addresses = addresses
    }
// sourcery:end
}
