//
//  SettingsUseCase.swift
//  Domain
//
//  Created by Andrew Chersky on 5/28/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol SettingsUseCase {
    var mapStyle: Property<MapStyle> { get }
    func updateMapStyle(_ style: MapStyle) -> SignalProducer<Void, Never>
}

public protocol HasSettingsUseCase {
    var settings: SettingsUseCase { get }
}
