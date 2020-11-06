//
//  PhoneConfirmationViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class PhoneConfirmationViewController: BaseViewController, ViewModelContainer {
    
    @IBOutlet private weak var codeView: ValidatableView!
    @IBOutlet private weak var continueButton: IndicatedGradientButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var sendAgainButton: UIButton!
    @IBOutlet private weak var sendAgainActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    func setupController() {
        addViewEndEditingOnTouch()
        scrollView.adjustInsetsOnKeyboardNotification(scrollingToBottom: true)
        codeView.textField.returnKeyType = .done
        codeView.textField.autocorrectionType = .no
        codeView.textField.textContentType = UITextContentType("")
    }
    
    func didSetViewModel(_ viewModel: PhoneConfirmationViewModel, lifetime: Lifetime) {
        let code = codeView.reactive.continuousTextValues
        let input: PhoneConfirmationViewModel.Input = PhoneConfirmationViewModel.Input(smsCode: code)
        let output = viewModel.transform(input)
        continueButton.reactive.pressed = CocoaAction(output.next)
        sendAgainButton.reactive.pressed = CocoaAction(output.sendAgain)
        continueButton.reactive.activity <~ output.next.isExecuting
        sendAgainActivityIndicator.reactive.isHidden <~ output.isSendAgainExecuting.negate()
        reactive.errors <~ Signal.merge(output.next.errors, output.sendAgain.errors)
        codeView.reactive.errors <~ output.validations.smsCode
    }
}
