//
//  User.swift
//  Platform
//
//  Created by Andrew Chersky  on 5/11/18.
//

import Foundation
import Domain
import Moya

extension API.Request {
    enum User: NetworkTargetType {
        case updateInfo(UpdatePersonForm, ofUserWithId: String)
        case updateSecret(UpdateSecretForm, ofUserWithId: String)
        
        var path: String {
            switch self {
            case .updateInfo:
                return "person/"
            case .updateSecret:
                return "person_secret/"
            }
        }
        
        var method: Moya.Method {
            return .post
        }
        
        var parameters: [String : Any] {
            switch self {
            case .updateInfo(let form, let id):
                var parameters: [String: Any] = ["uuid": id]
                if let firstName = form.firstName { parameters["first_name"] = firstName }
                if let lastName = form.lastName { parameters["last_name"] = lastName }
                if let patronymic = form.patronymic { parameters["second_name"] = patronymic }
                if let gender = form.gender { parameters["gender"] = gender.rawValue }
                if let birthDate = form.birthDate {
                    let dateString = DateFormatter.server.string(from: birthDate)
                    parameters["birthday"] = dateString
                }
                if let email = form.email { parameters["email"] = email }
                return ["person": parameters]
            case .updateSecret(let form, let id):
                let first = secretData(question: form.firstQuestion, answer: form.firstAnswer)
                let second = secretData(question: form.secondQuestion, answer: form.secondAnswer)
                let third = secretData(question: form.thirdQuestion, answer: form.thirdAnswer)
                let parameters = [
                    "secret": [
                        "uuid": id,
                        "secret_data": [first, second, third]
                    ]
                ]
                return parameters
            }
        }
        
        var needsToAddAppKeys: Bool {
            return false
        }
        
        private func secretData(question: String, answer: String) -> [String: Any] {
            return [
                "question": question,
                "answer": answer
            ]
        }
    }
}
