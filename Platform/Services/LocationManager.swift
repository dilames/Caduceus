//
//  LocationManager.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/23/18.
//

import Foundation
import CoreLocation
import ReactiveSwift
import Result

extension CLLocationManager {
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}

public final class LocationManager: NSObject {
    
    public typealias AuthorizationStatusCompletion = (Bool) -> Void
    
    // MARK: - Properties
    
    fileprivate let locationManager: CLLocationManager
    fileprivate let didChangeAuthorizationStatus = Signal<CLAuthorizationStatus, Never>.pipe()
    fileprivate let errors = Signal<Error, Never>.pipe()
    
    fileprivate lazy var _currentLocation: MutableProperty<CLLocation?> = .init(locationManager.location)
    private(set) lazy var currentLocation: CLLocation? = _currentLocation.value
    
    // MARK: - Lifecycle
    
    public override init() {
        locationManager = .init()
        super.init()
        setupService()
    }
    
    private func setupService() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Methods
    
    public func requestAlwaysAuthorization(_ completion: AuthorizationStatusCompletion? = nil) {
        locationManager.requestAlwaysAuthorization()
        handleAuthorizationRequest(completion)
    }
    
    public func requestWhenIsUseAuthorization(_ completion: AuthorizationStatusCompletion? = nil) {
        locationManager.requestWhenInUseAuthorization()
        handleAuthorizationRequest(completion)
    }
    
    private func handleAuthorizationRequest(_ completion: AuthorizationStatusCompletion?) {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            didChangeAuthorizationStatus.input.send(value: locationManager.authorizationStatus)
        }
        didChangeAuthorizationStatus.output
            .observeValues {
                switch $0 {
                case .authorizedAlways, .authorizedWhenInUse:
                    self.locationManager.startUpdatingLocation()
                    completion?(true)
                default:
                    self.locationManager.stopUpdatingLocation()
                    completion?(false)
                }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
        	didChangeAuthorizationStatus.input.send(value: status)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errors.input.send(value: error)
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _currentLocation.value = locations.first
    }
}

// MARK: - Reactive
public extension Reactive where Base: LocationManager {
    public var currentLocation: Property<CLLocation?> {
        return .init(base._currentLocation)
    }
    
    public var errors: Signal<Error, Never> {
        return base.errors.output
    }
    
    public var authorizationStatus: Property<CLAuthorizationStatus> {
        return Property(initial: .notDetermined, then: base.didChangeAuthorizationStatus.output)
    }
    
    public func requestAlwaysAuthorization() -> SignalProducer<Bool, Never> {
        return SignalProducer { observer, _ in
            self.base.requestAlwaysAuthorization {
                observer.send(value: $0)
                observer.sendCompleted()
            }
        }
    }
    
    public func requestWhenInUseAuthorization() -> SignalProducer<Bool, Never> {
        return SignalProducer { observer, _ in
            self.base.requestWhenIsUseAuthorization {
                observer.send(value: $0)
                observer.sendCompleted()
            }
        }
    }
}
