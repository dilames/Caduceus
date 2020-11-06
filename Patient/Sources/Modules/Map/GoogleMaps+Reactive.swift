//
//  GoogleMaps+Reactive.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/6/18.
//

import UIKit
import GoogleMaps
import ReactiveSwift
import Result
import CoreLocation

extension Reactive where Base: GMSMapView {
    func cameraPosition(zoom: CGFloat = 16.0) -> BindingTarget<CLLocation> {
        return makeBindingTarget {
            let position = GMSCameraPosition.camera(withTarget: $1.coordinate, zoom: Float(zoom))
            $0.animate(to: position)
        }
    }
    
    var showsCurrentLocationComponents: BindingTarget<Bool> {
        return makeBindingTarget {
            $0.isMyLocationEnabled = $1
            $0.settings.myLocationButton = $1
            $0.settings.compassButton = $1
        }
    }
    
    var mapStyle: BindingTarget<GMSMapStyle> {
        return makeBindingTarget { $0.mapStyle = $1 }
    }
}
