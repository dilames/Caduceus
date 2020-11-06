//
//  FamilyService.swift
//  Platform
//
//  Created by Andrew Chersky  on 5/31/18.
//

import Domain
import Foundation
import ReactiveSwift
import Result

final class FamilyService {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
}

// MARK: - FamilyListUseCase
extension FamilyService: FamilyListUseCase {
    func fetchFamilyMembers() -> SignalProducer<[Patient], AnyError> {
        return SignalProducer { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                let patients = [self.getRandomPatient(), self.getRandomPatient(), self.getRandomPatient()]
                observer.send(value: patients)
                observer.sendCompleted()
            })
        }
    }
}

// MARK: - SearchUserUseCase
extension FamilyService: SearchUsersUseCase {
    func search(by input: String) -> SignalProducer<[User], AnyError> {
        return SignalProducer { observer, _ in
            let testUsers = RMUser.testUsers.map { $0.asUser }
            let filtered = testUsers.filter {
                return ($0.firstName ?? "").range(of: input, options: .caseInsensitive) != nil ||
                    ($0.lastName ?? "").range(of: input, options: .caseInsensitive) != nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                if input.isEmpty {
                    observer.send(value: [])
                    observer.sendCompleted()
                } else {
                    observer.send(value: filtered)
                    observer.sendCompleted()
                }
            })
        }
    }
}

extension FamilyService {
    private func getRandomPatient() -> Patient {
        return Patient(
            id: UUID().uuidString,
            email: "email\(arc4random())@gmail.com",
            firstName: "Patient name \(arc4random_uniform(10))",
            lastName: "Patient last name \(arc4random_uniform(10))",
            patronymic: nil,
            phone: "Patient phone \(arc4random_uniform(10))",
            profile: Profile(birthDate: Date(), documents: [], addresses: []),
            secret: Secret(passphrase: "Smth"))
    }
}
