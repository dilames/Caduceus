//
//  IndicatorView.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/13/18.
//

import UIKit

final class SpinnerView: UIView {
    
    private let stroke: CAShapeLayer = .init()
    
    var radius: CGFloat {
        didSet {
            stroke.path = bezierPath.cgPath
        }
    }
    
    var style: SpinnerViewStyle {
        didSet {
            stroke.strokeColor = style.color.cgColor
        }
    }
    
    init(radius: CGFloat, style: SpinnerViewStyle = .white) {
        self.radius = radius
        self.style = style
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        radius = 13.0
        style = .white
        super.init(frame: frame)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        radius = 15
        style = .black
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stroke.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func setup() {
        stroke.path = bezierPath.cgPath
        stroke.lineWidth = 2.0
        stroke.strokeColor = UIColor.white.cgColor
        stroke.fillColor = nil
        stroke.backgroundColor = UIColor.gray.cgColor
        stroke.lineCap = kCALineCapRound
        layer.addSublayer(stroke)
    }
    
    private var bezierPath: UIBezierPath {
        let startAngle = -(CGFloat.pi / 2)
        let endAngle = startAngle + CGFloat.pi * 2 - CGFloat.pi / 5
        return UIBezierPath(
            arcCenter: .zero,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
    }
    
    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 0.7
        rotation.repeatCount = .infinity
        stroke.add(rotation, forKey: nil)
    }
    
    func stopAnimating() {
        stroke.removeAllAnimations()
    }
}

enum SpinnerViewStyle {
    case white
    case black
    case tint
    case gray
    
    var color: UIColor {
        switch self {
        case .black:
            return .black
        case .white:
            return .white
        case .tint:
            return .cornflowerBlue
        case .gray:
            return .steelTwo
        }
    }
}
