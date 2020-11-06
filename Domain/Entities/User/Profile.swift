//
//  UserProfile.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/22/18.
//

import Foundation

public struct Profile {
    let birthDate: Date
    let documents: [Document]
    let addresses: [Address]

// sourcery:inline:auto:Profile.AutoPublicStruct
// DO NOT EDIT
    public init(
		birthDate: Date,
        documents: [Document],
        addresses: [Address])
	{
        self.birthDate = birthDate
        self.documents = documents
        self.addresses = addresses
    }
// sourcery:end
}
