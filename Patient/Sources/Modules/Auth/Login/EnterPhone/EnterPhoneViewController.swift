//
//  EnterPhoneViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import UIKit
import PhoneNumberKit
import ReactiveSwift
import ReactiveCocoa
import Platform

final class EnterPhoneViewController: BaseViewController, ViewModelContainer {
    
    @IBOutlet private weak var phoneView: ValidatableView!
    @IBOutlet private weak var passwordView: ValidatableView!
    @IBOutlet private weak var nextButton: IndicatedGradientButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        configureFields()
    }
    
    func setupController() {
        addViewEndEditingOnTouch()
        scrollView.adjustInsetsOnKeyboardNotification(scrollingToBottom: true)
        let closeItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = closeItem
    }
    
    private func configureFields() {
        phoneView.placeholder = R.string.localizable.phoneNumber()
        phoneView.textField.keyboardType = .numberPad
    	phoneView.textField.textContentType = UITextContentType("")
        phoneView.textField.setMaskType(.ukrainianPhoneNumber)
        phoneView.textField.autocorrectionType = .no
        passwordView.placeholder = R.string.localizable.password()
        passwordView.textField.returnKeyType = .done
        passwordView.textField.textContentType = UITextContentType("")
        passwordView.textField.isSecureTextEntry = true
        passwordView.textField.autocorrectionType = .no
    }
    
    func didSetViewModel(_ viewModel: EnterPhoneViewModel, lifetime: Lifetime) {
        let phone = phoneView.textField.reactive.continuousTextValuesSkippingMask().map { "+" + $0 }
        let password = passwordView.reactive.continuousTextValues.mapWithoutWhitespaces()
        let input = EnterPhoneViewModel.Input(phone: phone, password: password)
        let output = viewModel.transform(input)
        nextButton.reactive.pressed = CocoaAction(output.next)
        nextButton.reactive.activity <~ output.next.isExecuting
        reactive.errors <~ output.next.errors
        phoneView.reactive.errors <~ output.validations.phone
        passwordView.reactive.errors <~ output.validations.password
        navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(output.close)
    }
}
