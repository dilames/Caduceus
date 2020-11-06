//
//  SearchPlaceholderView.swift
//  Patient
//
//  Created by Andrew Chersky  on 6/1/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

private enum Constant {
    static let placeholder: String = "Type a name of a person\nyou want to search"
}

final class SearchPlaceholderView: UIView {

    private let label: UILabel
    
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.constrainToSuperview(insetedBy: 20)
        
        backgroundColor = .white
        label.text = Constant.placeholder
        label.textColor = .cornflowerBlue
        label.textAlignment = .center
        label.numberOfLines = 0
    }
}
