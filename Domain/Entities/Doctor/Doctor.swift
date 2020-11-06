//
//  Doctor.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/24/18.
//

import Foundation

public struct Doctor {
    let position: String
    let person: User
    let divisions: [Division]
    let educations: [Education]
    let specialties: [Specialty]

// sourcery:inline:auto:Doctor.AutoPublicStruct
// DO NOT EDIT
    public init(
		position: String,
        person: User,
        divisions: [Division],
        educations: [Education],
        specialties: [Specialty])
	{
        self.position = position
        self.person = person
        self.divisions = divisions
        self.educations = educations
        self.specialties = specialties
    }
// sourcery:end
}
