//
//  JsonReader.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/17/18.
//

import UIKit

final class JsonReader {

    enum JsonReadingError: LocalizedError {
        case missingFile(File)
        case wrongFileStructure(File)
        
        var errorDescription: String? {
            switch self {
            case .missingFile(let file):
                return "File named \"\(file)\" is missing"
            case .wrongFileStructure(let file):
                return "Wrong Structure of file \"\(file)\""
            }
        }
    }
    
    enum File: String {
        case registartionStepFirst = "RegistrationStepFirst"
        case verifyPhone = "PhoneVerification"
    }
    
    static func jsonData(from file: File) throws -> Data {
        let fileUrl = try jsonURL(from: file)
        let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let json = jsonObject as? [String: Any], json[Constant.dataKey] != nil {
            return data
        } else {
         	throw JsonReadingError.wrongFileStructure(file)
        }
    }
    
    static func jsonURL(from file: File) throws -> URL {
        guard let url = Bundle.main.url(forResource: file.rawValue, withExtension: Constant.jsonExtension) else {
            throw JsonReadingError.missingFile(file)
        }
        return url
    }
}

private enum Constant {
    static let jsonExtension: String = "json"
    static let dataKey: String = "data"
}
