//
//  Environment.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Platform

/// Actual baseURL = https://pre.caduceus.com.ua/api/v1/
enum Environment: PlatformEnvironment {
    
    case develop
    
    static let current: Environment = develop
    
    var baseURL: URL {
        return URL(string: baseUrlString)!
    }
    
    private var baseUrlString: String {
        return "\(scheme)://\(configuration).\(hostName)/\(api)/\(apiVersion)/"
    }
    
    private var scheme: String {
        return "https"
    }
    
    private var configuration: String {
        return "pre"
    }
    
    private var hostName: String {
        return "caduceus.com.ua"
    }
    
    private var api: String {
        return "api"
    }
    
    private var apiVersion: String {
        return "v1"
    }
}

// API Keys
extension Environment {
    var googleMapsAPIKey: String { return "AIzaSyCnPNagx0JY9H-dGrVuKp_P9pOwltA10CU" }
}
