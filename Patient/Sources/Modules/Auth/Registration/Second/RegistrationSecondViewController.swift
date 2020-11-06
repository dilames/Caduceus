//
//  RegistrationSecondViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/6/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Extensions

final class RegistrationSecondViewController: BaseViewController, ViewModelContainer {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var smsView: ValidatableView!
    @IBOutlet private weak var passwordView: ValidatableView!
    @IBOutlet private weak var confirmPasswordView: ValidatableView!
    @IBOutlet private weak var sendSmsAgainButton: UIButton!
    @IBOutlet private weak var nextButton: IndicatedGradientButton!
    @IBOutlet private weak var sendAgainIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var completeButton: IndicatedButton!
    
    var textFields: [UITextField] {
        return [smsView.textField, passwordView.textField, confirmPasswordView.textField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        configureFields()
    }
    
    private func setupController() {
        addViewEndEditingOnTouch()
        scrollView.adjustInsetsOnKeyboardNotification()
        textFields.forEach {$0.delegate = self}
        completeButton.activityStyle = .tint
    }
    
    private func configureFields() {
        textFields.forEach {
            $0.autocorrectionType = .no
            $0.textContentType = UITextContentType("")
        }
        smsView.textField.returnKeyType = .next
        passwordView.textField.isSecureTextEntry = true
        passwordView.textField.returnKeyType = .next
        confirmPasswordView.textField.isSecureTextEntry = true
        confirmPasswordView.textField.returnKeyType = .done
    }
    
    func didSetViewModel(_ viewModel: RegistrationSecondViewModel, lifetime: Lifetime) {
        let smsCode = smsView.reactive.continuousTextValues
        let password = passwordView.reactive.continuousTextValues
        let confirmPassword = confirmPasswordView.reactive.continuousTextValues
        let input = RegistrationSecondViewModel.Input(smsCode: smsCode, password: password, confirmPassword: confirmPassword)
        let output = viewModel.transform(input)
        
        nextButton.reactive.pressed = CocoaAction(output.next)
        sendSmsAgainButton.reactive.pressed = CocoaAction(output.sendAgain)
        completeButton.reactive.pressed = CocoaAction(output.complete)
        nextButton.reactive.activity <~ output.next.isExecuting
        completeButton.reactive.activity <~ output.complete.isExecuting
        sendAgainIndicator.reactive.isHidden <~ output.isSendAgainExecuting.negate()
        
        reactive.errors <~ Signal.merge(output.next.errors, output.sendAgain.errors)
        smsView.reactive.errors <~ output.validations.smsCode
        passwordView.reactive.errors <~ output.validations.password
        confirmPasswordView.reactive.errors <~ output.validations.confirmPassword
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationSecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let index = textFields.index(of: textField),
            let nextTextField = textFields[safe: index + 1] else {
                return true
        }
        nextTextField.becomeFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == confirmPasswordView.textField {
            DispatchQueue.main.async {
                self.scrollView.scrollToBottom(animated: true)
            }            
        }
        return true
    }
}
