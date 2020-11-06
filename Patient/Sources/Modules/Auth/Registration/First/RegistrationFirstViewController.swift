//
//  RegistrationViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/5/18.
//

import UIKit
import PhoneNumberKit
import ReactiveSwift
import ReactiveCocoa

final class RegistrationFirstViewController: BaseViewController, ViewModelContainer {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var phoneView: ValidatableView!
    @IBOutlet private weak var nextButton: IndicatedGradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        addViewEndEditingOnTouch()
        scrollView.adjustInsetsOnKeyboardNotification(scrollingToBottom: true)
        let closeItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = closeItem
        phoneView.textField.keyboardType = .numberPad
        phoneView.textField.textContentType = UITextContentType("")
        phoneView.textField.setMaskType(.ukrainianPhoneNumber)
    }
    
    func didSetViewModel(_ viewModel: RegistrationFirstViewModel, lifetime: Lifetime) {
        let phone = phoneView.textField.reactive.continuousTextValuesSkippingMask().map { "+" + $0 }
        let input = RegistrationFirstViewModel.Input(phoneNumber: phone)
        let output = viewModel.transform(input)
        nextButton.reactive.pressed = CocoaAction(output.next)
        nextButton.reactive.activity <~ output.next.isExecuting
        navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(output.close)
        reactive.errors <~ output.next.errors
        phoneView.reactive.errors <~ output.validations.phoneNumber
    }
}
