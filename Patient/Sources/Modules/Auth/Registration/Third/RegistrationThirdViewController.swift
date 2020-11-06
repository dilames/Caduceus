//
//  RegistrationThirdViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/6/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Extensions

final class RegistrationThirdViewController: BaseViewController, ViewModelContainer {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var patronymicTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var dateOfBirthButton: UIButton!
    @IBOutlet private weak var nextButton: IndicatedGradientButton!
    
    // MARK: - Properties
    
    var textFields: [UITextField]  {
        return [firstNameTextField, lastNameTextField, patronymicTextField, emailTextField]
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        addViewEndEditingOnTouch()
        scrollView.adjustInsetsOnKeyboardNotification()        
        textFields.forEach {$0.delegate = self}
    }
    
    // MARK: - ViewModelContainer
    
    func didSetViewModel(_ viewModel: RegistrationThirdViewModel, lifetime: Lifetime) {
        let output = viewModel.transform(input)
        nextButton.reactive.pressed = CocoaAction(output.next)
        output.birthDate <~ dateOfBirthButton.reactive.controlEvents(.touchUpInside).map { _ in output.selectedDate.value}
        nextButton.reactive.activity <~ output.next.isExecuting        
        dateOfBirthLabel.reactive.text <~ output.birthDate.values
            .map {$0?.readableDescription ??
                output.selectedDate.value?.readableDescription ??
                R.string.localizable.dateOfBirth()}
        output.birthDate.values.observeValues { [weak self] date in
            if date != nil {
            	self?.dateOfBirthLabel.textColor = .cornflowerBlue
            }
        }
        genderSegmentedControl.sendActions(for: .valueChanged)
        reactive.errors <~ output.next.errors
    }
    
    var input: RegistrationThirdViewModel.Input {
        let firstName = firstNameTextField.reactive.continuousTextValues
        let lastName = lastNameTextField.reactive.continuousTextValues
        let patronymic = patronymicTextField.reactive.continuousTextValues
        let genderIndex = genderSegmentedControl.reactive.selectedSegmentIndexes
        let email = emailTextField.reactive.continuousTextValues
        let input = RegistrationThirdViewModel.Input(
            firstName: firstName,
            lastName: lastName,
            patronymic: patronymic,
            genderIndex: genderIndex,
            email: email
        )
        return input
    }
} 

// MARK: - UITextFieldDelegate
extension RegistrationThirdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let index = textFields.index(of: textField),
            let nextTextField = textFields[safe: index + 1],
        	textField != patronymicTextField else {
                return true
        }
        nextTextField.becomeFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            DispatchQueue.main.async {
                self.scrollView.scrollToBottom(animated: true)
            }
        }
        return true
    }
}
