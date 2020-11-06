//
//  MapViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import Foundation
import GoogleMaps.GMSMapStyle
import ReactiveSwift
import Result
import Domain

final class MapViewModel: ViewModel {
    
    typealias UseCases = HasLocationUseCase & HasSettingsUseCase
    
    struct Output {
        let mapStyle: Property<MapStyle>
        let currentLocation: Property<CLLocation?>
        let isMyLocationEnabled: Bool
        let isStatusAuthorized: Property<Bool>
    }
    
    private let useCases: UseCases
    private let isMyLocationEnabled: Bool
    
    init(isMyLocationEnabled: Bool, useCases: UseCases) {
        self.useCases = useCases
        self.isMyLocationEnabled = isMyLocationEnabled
    }
    
    deinit {
        readablePrint(#function, of: self)
    }
    
    func transform(_ input: Void) -> MapViewModel.Output {
        let mapStyle = useCases.settings.mapStyle
        let locationProducer = useCases.location.getCurrentLocation()
        let currentLocation = MutableProperty<CLLocation?>(nil)
        currentLocation <~ locationProducer
        let isStatusAuthorized = useCases.location.isAuthorized
        useCases.location.getCurrentLocation().start()
        return Output(
            mapStyle: mapStyle,
            currentLocation: Property(currentLocation),
            isMyLocationEnabled: isMyLocationEnabled,
            isStatusAuthorized: isStatusAuthorized)
    }
}
