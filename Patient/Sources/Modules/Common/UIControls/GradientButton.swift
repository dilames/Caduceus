//
//  GradientButton.swift
//  Patient
//
//  Created by Andrew Chersky on 3/5/18.
//

import UIKit

@IBDesignable
final class GradientButton: UIButton {
    
    // MARK: - Variables
    var type: CAGradientLayer.CAGradientType = .horizontal {
        didSet {
            gradientLayer.configure(type: type, colors: colors)
        }
    }
    var colors: [UIColor] = [.softBlue, .cornflowerBlue] {
        didSet {
            gradientLayer.configure(type: type, colors: colors)
        }
    }
    
    // MARK: - Private variables
    private var gradientLayer: CAGradientLayer!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer = CAGradientLayer(frame: frame, type: type, colors: colors)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        gradientLayer = CAGradientLayer(type: type, colors: colors)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    override var isEnabled: Bool {
        willSet {
            isHighlighted = !newValue
        }
    }
}
