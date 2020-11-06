//
//  NetworkTargetType.swift
//  Platform
//
//  Created by Andrew Chersky  on 2/20/18.
//

import Foundation
import Moya

protocol NetworkTargetType: TargetType {
    var parameters: [String: Any] { get }
    var sampleDataFile: JsonReader.File? { get }
    var needsToAddAppKeys: Bool { get }
    var scopes: [Scope] { get }
}

extension NetworkTargetType {
    var baseURL: URL {
        if let baseURL = Platform.baseURL {
            return baseURL
        }
        fatalError("Base URL for Platform was not set.")
    }
    
    var task: Task {
        var parameters = self.parameters
        if needsToAddAppKeys {
            parameters["client_id"] = Constants.Client.id
            parameters["client_secret"] = Constants.Client.secret
        }
        if !scopes.isEmpty {
        	parameters["scope"] = scopes.map {$0.rawValue}.joined(separator: ", ")
        }
        switch method {
        case .get, .head, .delete:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var sampleData: Data {
        if let file = sampleDataFile {
            do {
                return try JsonReader.jsonData(from: file)
            } catch {
                print(error.localizedDescription)
            }
        }
        return Data()
    }
    
    var sampleDataFile: JsonReader.File? {
    	return nil
    }
}

extension NetworkTargetType {
    var needsToAddAppKeys: Bool {
        return false
    }
    
    var scopes: [Scope] {
        return []
    }
}
