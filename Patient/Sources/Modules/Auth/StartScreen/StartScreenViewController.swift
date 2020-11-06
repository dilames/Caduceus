//
//  StartScreenViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/5/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

private enum AnimationConst {
    static let translation: TimeInterval = 0.6
    static let fadeIn: TimeInterval = 0.5
}

final class StartScreenViewController: BaseViewController, ViewModelContainer {

    @IBOutlet private weak var titleBottomMore: NSLayoutConstraint!
    @IBOutlet private weak var titleBottomLess: NSLayoutConstraint!
    @IBOutlet private weak var loginButton: GradientButton!
    @IBOutlet private weak var registerButton: GradientButton!
    @IBOutlet private weak var guestView: UIView!
    @IBOutlet private weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        loginButton.alpha = 0.0
        registerButton.alpha = 0.0
        guestView.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.view.layoutIfNeeded()
            self.titleBottomLess.isActive = false
            self.titleBottomMore.isActive = true
            
            UIView.animate(withDuration: AnimationConst.translation, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: AnimationConst.fadeIn, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.loginButton.alpha = 1.0
                    self.registerButton.alpha = 1.0
                    self.guestView.alpha = 1.0
                }, completion: nil)
            })
        }
    }
    
    func didSetViewModel(_ viewModel: StartScreenViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        loginButton.reactive.pressed = CocoaAction(output.login)
        registerButton.reactive.pressed = CocoaAction(output.register)
        guestButton.reactive.pressed = CocoaAction(output.enterAsGuest)
    }
}
