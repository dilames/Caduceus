//
//  NewsPreviewView.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/5/18.
//

import UIKit
import VisualEffectView

class NewsPreviewView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moreButtonBlurView: VisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     	setupView()
        setupBlurView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moreButtonBlurView.layer.cornerRadius = moreButton.bounds.height / 2.0
    }
    
    private func setupView() {
        moreButtonBlurView.layer.borderColor = UIColor.lightGray.cgColor
        moreButtonBlurView.layer.borderWidth = 0.5
        additionalInfoLabel.layer.shadowColor = UIColor.black.cgColor
        additionalInfoLabel.layer.shadowOpacity = 0.5
        additionalInfoLabel.layer.shadowOffset = .zero
    }
    
    private func setupBlurView() {
        moreButtonBlurView.colorTint = .white
        moreButtonBlurView.colorTintAlpha = 0.8
        moreButtonBlurView.blurRadius = 5
        moreButtonBlurView.scale = 1
    }
}
