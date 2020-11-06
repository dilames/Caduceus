//
//  LocationService.swift
//  Platform
//
//  Created by Andrew Chersky on 5/2/18.
//

import Foundation
import Domain
import ReactiveSwift
import Result
import CoreLocation.CLLocation

final class LocationService: LocationUseCase {
    
    private let locationManager = LocationManager()
    
    // MARK: LocationUseCase
    
    var isAuthorized: Property<Bool> {
        return locationManager.reactive
            .authorizationStatus
            .map { $0 == .authorizedAlways || $0 == .authorizedWhenInUse }
    }
    
    func getCurrentLocation() -> SignalProducer<CLLocation?, Never> {
        return locationManager.reactive
            .requestAlwaysAuthorization()
            .flatMap { $0 ? self.locationManager.reactive.currentLocation.producer : .init(value: nil) }
    }
}
