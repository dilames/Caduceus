//
//  CAGradientLayer.swift
//  Patient
//
//  Created by Andrew Chersky on 3/2/18.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    typealias CAGradientVector = (
        startPoint: CGPoint, endPoint: CGPoint)
    
    enum CAGradientType: Int {
        
        case horizontal
        case vertical
        case mainDiagonal
        case antiDiagonal
        
        var vector: CAGradientVector {
            let points: [CAGradientType: CAGradientVector] = [
                .horizontal: (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5)),
                .vertical: (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1)),
                .mainDiagonal: (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)),
                .antiDiagonal: (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
            ]
            return points[self]!
        }
    }
    
    func configure(
        type: CAGradientType,
        colors: [UIColor]? = nil) {
        self.startPoint = type.vector.startPoint
        self.endPoint = type.vector.endPoint
        self.colors = colors?.map({ $0.cgColor })
    }
    
    convenience init(
        frame: CGRect = .zero,
        type: CAGradientType = .horizontal,
        colors: [UIColor]? = nil) {
        self.init()
        self.configure(type: type, colors: colors)
    }
    
}

public extension CAGradientLayer {
    
    var image: UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
