//
//  AccessTokenProvider.swift
//  Platform
//
//  Created by Andrew Chersky  on 5/2/18.
//

import Foundation
import ReactiveSwift
import Result

protocol AccessTokenProvider: class {
    var accessToken: Property<AccessToken?> { get }
    func refreshToken(else error: Error) -> SignalProducer<Void, AnyError>
}
