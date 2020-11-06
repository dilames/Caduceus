//
//  MapViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/29/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import GoogleMaps

final class MapViewController: BaseViewController, ViewModelContainer {

    fileprivate var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mapView
    }
    
    func didSetViewModel(_ viewModel: MapViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        mapView.reactive.mapStyle <~ output.mapStyle.producer.map { $0.toGMS() }
        mapView.reactive.cameraPosition() <~ output.currentLocation.producer.skipNil()
        mapView.reactive.showsCurrentLocationComponents <~ output.isStatusAuthorized
    }
}
