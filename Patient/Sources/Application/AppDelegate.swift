//
//  AppDelegate.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/19/18.
//

import UIKit
import Platform
import GoogleMaps

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let environment: Environment = .current
    private lazy var platform: Platform = Platform(environment: environment)
    private lazy var appCoordinator = AppCoordinator(useCases: platform)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = appCoordinator.window
        GMSServices.provideAPIKey(environment.googleMapsAPIKey)
        return true
    }
}
