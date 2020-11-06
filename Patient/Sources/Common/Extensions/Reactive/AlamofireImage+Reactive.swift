//
//  AlamofireImage+Reactive.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import UIKit
import AlamofireImage
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UIImageView {
    func image(animatedWith imageTransition: UIImageView.ImageTransition? = nil,
               placeholder: UIImage? = nil,
               filter: ImageFilter? = nil) -> BindingTarget<URL?> {
        return makeBindingTarget {
            if let url = $1 {
                $0.af_setImage(withURL: url,
                               placeholderImage: placeholder,
                               filter: filter)
            }
        }
    }
}

extension Reactive where Base: UIButton {
    func image(placeholder: UIImage? = nil,
               filter: ImageFilter? = nil) -> BindingTarget<URL?> {
        return makeBindingTarget {
            if let url = $1 {
                $0.af_setImage(for: .normal,
                               url: url,
                               placeholderImage: placeholder,
                               filter: filter)
            }
        }
    }
}
