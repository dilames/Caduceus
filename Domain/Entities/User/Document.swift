//
//  UserDocument.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/22/18.
//

import Foundation

public struct Document {
    let id: String
//    let type: Int
    let serial: String
    let stateDepartment: String
    let number: String
    let startDate: Date
    let endDate: Date

// sourcery:inline:auto:Document.AutoPublicStruct
// DO NOT EDIT
    public init(
		id: String,
        serial: String,
        stateDepartment: String,
        number: String,
        startDate: Date,
        endDate: Date)
	{
        self.id = id
        self.serial = serial
        self.stateDepartment = stateDepartment
        self.number = number
        self.startDate = startDate
        self.endDate = endDate
    }
// sourcery:end
}
