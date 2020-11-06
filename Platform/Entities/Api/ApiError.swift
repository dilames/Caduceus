//
//  ApiError.swift
//  Platform
//
//  Created by Andrew Chersky  on 5/11/18.
//

import Foundation

struct ApiError: LocalizedError, Decodable {
    let code: Int
    let message: String
    
    var errorDescription: String? {
        return message
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case message = "error"
    }
}
