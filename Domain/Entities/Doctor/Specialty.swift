//
//  Specialities.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/24/18.
//

import Foundation

public struct Specialty {
    let specialty: String
    let officio: String
    let level: String
    let type: String
    let attestationName: String
    let attestationDate: Date
    let validTillDate: Date
    let certificateNumber: String

// sourcery:inline:auto:Specialty.AutoPublicStruct
// DO NOT EDIT
    public init(
		specialty: String,
        officio: String,
        level: String,
        type: String,
        attestationName: String,
        attestationDate: Date,
        validTillDate: Date,
        certificateNumber: String)
	{
        self.specialty = specialty
        self.officio = officio
        self.level = level
        self.type = type
        self.attestationName = attestationName
        self.attestationDate = attestationDate
        self.validTillDate = validTillDate
        self.certificateNumber = certificateNumber
    }
// sourcery:end
}
