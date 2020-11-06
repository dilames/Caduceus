//
//  UIView+.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/7/18.
//

import UIKit

extension UIView {    
    func setAndAlignPositionOf(anchorPoint: CGPoint) {
        let newPoint = CGPoint(x: bounds.width * anchorPoint.x, y: bounds.height * anchorPoint.y)
        let oldPoint = CGPoint(x: bounds.width * layer.anchorPoint.x, y: bounds.height * layer.anchorPoint.y)
        
        newPoint.applying(transform)
        oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
}
