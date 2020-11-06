//
//  LocationUseCase.swift
//  Domain
//
//  Created by Andrew Chersky on 5/2/18.
//

import Foundation
import CoreLocation.CLLocation
import ReactiveSwift
import Result

public protocol LocationUseCase {
    var isAuthorized: Property<Bool> { get }
    func getCurrentLocation() -> SignalProducer<CLLocation?, Never>
}

public protocol HasLocationUseCase {
    var location: LocationUseCase { get }
}
