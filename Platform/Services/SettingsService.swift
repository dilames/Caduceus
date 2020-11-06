//
//  SettingsService.swift
//  Platform
//
//  Created by Andrew Chersky on 5/28/18.
//

import Foundation
import Domain
import ReactiveSwift
import Result

private enum SettingKey {
    static let mapStyle = "kSettingMapStyle"
}

final class SettingsService: SettingsUseCase {
    
    let _mapStyle: MutableProperty<MapStyle>
    lazy var mapStyle: Property<MapStyle> = .init(_mapStyle)
    
    init() {
        let rawStyle = UserDefaults.standard.integer(forKey: SettingKey.mapStyle)
        _mapStyle = .init(MapStyle(rawValue: rawStyle) ?? .blue)
        _mapStyle.signal.observeValues({
            UserDefaults.standard.set($0.rawValue, forKey: SettingKey.mapStyle)
            UserDefaults.standard.synchronize()
        })
    }
    
    func updateMapStyle(_ style: MapStyle) -> SignalProducer<Void, Never> {
        _mapStyle.value = style
        return .executingEmpty
    }
}
