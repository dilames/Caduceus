//
//  RMUser+TestValues.swift
//  Platform
//
//  Created by Andrew Chersky  on 6/1/18.
//

import Foundation
import Domain

// MARK: - Test Users
extension RMUser {
    public static var johnSmith: RMUser {
        return RMUser(user: User(
            id: "Test id 1",
            email: "john.smith@gmail.com",
            firstName: "John",
            lastName: "Smith",
            patronymic: nil,
            phone: "+380324561232",
            profile: nil,
            secret: nil))
    }
    
    public static var sarahConnor: RMUser {
        return RMUser(user: User(
            id: "Test id 2",
            email: "sarah.connor@gmail.com",
            firstName: "Sarah",
            lastName: "Connor",
            patronymic: nil,
            phone: "+320324565432",
            profile: nil,
            secret: nil))
    }
    
    public static var johnDoe: RMUser {
        return RMUser(user: User(
            id: "Test id 3",
            email: "john.doe@gmail.com",
            firstName: "John",
            lastName: "Doe",
            patronymic: nil,
            phone: "+12312321331",
            profile: nil,
            secret: nil))
    }
    
    public static var testUsers: [RMUser] {
        return [johnSmith, sarahConnor, johnDoe]
    }
}
