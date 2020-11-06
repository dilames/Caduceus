//
//  DoctorEducation.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/24/18.
//

import Foundation

public struct Education {
    let country: String
    let city: String
    let institution: String
    let degree: String
    let issuedDate: Date

// sourcery:inline:auto:Education.AutoPublicStruct
// DO NOT EDIT
    public init(
		country: String,
        city: String,
        institution: String,
        degree: String,
        issuedDate: Date)
	{
        self.country = country
        self.city = city
        self.institution = institution
        self.degree = degree
        self.issuedDate = issuedDate
    }
// sourcery:end
}
