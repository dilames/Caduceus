//
//  MapStyle + Extensions.swift
//  Patient
//
//  Created by Andrew Chersky on 5/2/18.
//

import Foundation
import Domain
import GoogleMaps.GMSMapStyle

extension MapStyle {
    enum MapStyleReadingError: LocalizedError {
        case missingFile(String)
        
        var errorDescription: String? {
            switch self {
            case .missingFile(let file): return "File named \"\(file)\" is missing"
            }
        }
    }
    
    private var files: [MapStyle: URL?] {
        return [
            .blue:      R.file.mapStyleBlueJson(),
            .dark:      R.file.mapStyleDarkJson(),
            .darkBlue:  R.file.mapStyleDarkBlueJson(),
            .greenBlue: R.file.mapStyleGreenBlueJson(),
            .red:       R.file.mapStyleRedJson()
        ]
    }
    
    var color: UIColor {
        switch self {
        case .blue: return .blue
        case .dark: return .black
        case .darkBlue: return .darkSlateBlue
        case .greenBlue: return .green
        case .red: return .red
        }
    }
    
    var title: String {
        switch self {
        case .blue: return "Blue"
        case .dark: return "Dark"
        case .darkBlue: return "Dark Blue"
        case .greenBlue: return "Green Blue"
        case .red: return "Red"
        }
    }
    
    @discardableResult func toGMS() -> GMSMapStyle {
        guard let file = files[self], let url = file else {
            let error = MapStyleReadingError.missingFile(String(describing: self))
            print("Google Map Style Error: \(error); \(error.errorDescription ?? "")")
            fatalError()
        }
        
        return (try? GMSMapStyle(contentsOfFileURL: url)) ?? .init()
    }
}
