//
//  RMUserDocument.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import Foundation
import RealmSwift
import Domain

@objcMembers final class RMDocument: Object, AutoCodable {
    dynamic var id: String = ""
    dynamic var type: String = ""
    dynamic var serial: String = ""
    dynamic var stateDepartment: String = ""
    dynamic var number: String = ""
    dynamic var startDate: Date = Date()
    dynamic var endDate: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case serial
        case stateDepartment = "state_department"
        case number
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

// MARK: - DomainConvertible
extension RMDocument {
    var asDomain: Document {
        return Document(
            id: id,
            serial: serial,
            stateDepartment: stateDepartment,
            number: number,
            startDate: startDate,
            endDate: endDate
        )
    }
}
