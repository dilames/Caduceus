//
//  Templates.swift
//  Platform
//
//  Created by Andrew Chersky  on 3/16/18.
//

import Foundation

protocol AutoDecodable: Decodable {}
protocol AutoEncodable: Encodable {}
protocol AutoCodable: AutoDecodable, AutoEncodable {}

extension AutoDecodable {
    var dateFormatter: DateFormatter {
        return DateFormatter()
    }
}

extension AutoEncodable {
    var dateFormatter: DateFormatter {
        return DateFormatter()
    }
}

extension AutoCodable {
    var dateFormatter: DateFormatter {
        return DateFormatter()
    }
}
