//
//  CommonHeaderView.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/13/18.
//

import UIKit

class CommonHeaderView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTop: NSLayoutConstraint!
    @IBOutlet private weak var titleBottom: NSLayoutConstraint!
    @IBOutlet private weak var titleLeading: NSLayoutConstraint!
    @IBOutlet private weak var titleTrailing: NSLayoutConstraint!
    
    // MARK: - Public properties
    
    var text: String = ""
    var font: UIFont = .systemFont(ofSize: 15.0)
    var textColor: UIColor = .black
    var labelInsets: UIEdgeInsets = .zero
    var textAlignment: NSTextAlignment = .center
    
    // MARK: - Methods
    
    private func configureUI() {
        titleLabel.text = text
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.textAlignment = textAlignment
        titleTop.constant = labelInsets.top
        titleBottom.constant = labelInsets.bottom
        titleLeading.constant = labelInsets.left
        titleTrailing.constant = labelInsets.right
    }

    static func instantiateFromNib(
        text: String,
        textColor: UIColor,
        textFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: .semibold),
        labelInsets: UIEdgeInsets = .zero,
        textAlignment: NSTextAlignment = .center)
        -> CommonHeaderView
    {
    	let header = instantiateFromNib()
        header.text = text
        header.font = textFont
        header.textColor = textColor
        header.labelInsets = labelInsets
        header.textAlignment = textAlignment
        header.configureUI()
        return header
    }
}
