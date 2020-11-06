//
//  RegistrationFourthViewController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/6/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class RegistrationFourthViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var firstQuestionButton: GradientButton!
    @IBOutlet private weak var secondQuestionButton: GradientButton!
    @IBOutlet private weak var thirdQuestionButton: GradientButton!
    @IBOutlet private weak var nextButton: IndicatedGradientButton!
    
    @IBOutlet private weak var firstQuestionLabel: UILabel!
    @IBOutlet private weak var secondQuestionLabel: UILabel!
    @IBOutlet private weak var thirdQuestionLabel: UILabel!
    
    @IBOutlet weak var firstAnswerView: ValidatableView!
    @IBOutlet weak var secondAnswerView: ValidatableView!
    @IBOutlet weak var thirdAnswerView: ValidatableView!
    
    // MARK: - Properties
    
    var textFields: [UITextField] {
        return [firstAnswerView, secondAnswerView, thirdAnswerView].map { $0.textField }
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
}

// MARK: - ViewModelContainer
extension RegistrationFourthViewController: ViewModelContainer {
    func didSetViewModel(_ viewModel: RegistrationFourthViewModel, lifetime: Lifetime) {
        let input = collectInput()
        let output = viewModel.transform(input)
        bind(output)
        bindComponents(to: output)
        bindLabels(to: output)
        bindTextFields(to: output)
    }
    
    private func collectInput() -> RegistrationFourthViewModel.Input {
        let firstAnswer = firstAnswerView.reactive.continuousTextValues
        let secondAnswer = secondAnswerView.reactive.continuousTextValues
        let thirdAnswer = thirdAnswerView.reactive.continuousTextValues
        let input = RegistrationFourthViewModel.Input(
            firstAnswer: firstAnswer,
            secondAnswer: secondAnswer,
            thirdAnswer: thirdAnswer)
        return input
    }
    
    private func bind(_ output: RegistrationFourthViewModel.Output) {
        output.didTapFirstQuestion <~ firstQuestionButton.reactive.controlEvents(.touchUpInside)
            .map { _ in output.firstQuestion.value }
        output.didTapSecondQuestion <~ secondQuestionButton.reactive.controlEvents(.touchUpInside)
            .map { _ in output.secondQuestion.value }
        output.didTapThirdQuestion <~ thirdQuestionButton.reactive.controlEvents(.touchUpInside)
            .map { _ in output.thirdQuestion.value }
    }
    
    private func bindComponents(to output: RegistrationFourthViewModel.Output) {
        nextButton.reactive.pressed = CocoaAction(output.next)
        nextButton.reactive.activity <~ output.next.isExecuting
        reactive.errors <~ output.next.errors
    }
    
    private func bindLabels(to output: RegistrationFourthViewModel.Output) {
        firstQuestionLabel.reactive.text <~ output.didTapFirstQuestion.values
            .map { $0 ?? output.firstQuestion.value ?? R.string.localizable.chooseQuestion() }
        secondQuestionLabel.reactive.text <~ output.didTapSecondQuestion.values
            .map { $0 ?? output.secondQuestion.value ?? R.string.localizable.chooseQuestion() }
        thirdQuestionLabel.reactive.text <~ output.didTapThirdQuestion.values
            .map { $0 ?? output.thirdQuestion.value ?? R.string.localizable.chooseQuestion() }
    }
    
    private func bindTextFields(to output: RegistrationFourthViewModel.Output) {
        firstAnswerView.textField.reactive.becomeFirstResponder <~ output.didTapFirstQuestion.values
            .skipNil().filter { !$0.isEmpty }.mapToVoid()
        secondAnswerView.textField.reactive.becomeFirstResponder <~ output.didTapSecondQuestion.values
            .skipNil().filter { !$0.isEmpty }.mapToVoid()
        thirdAnswerView.textField.reactive.becomeFirstResponder <~ output.didTapThirdQuestion.values
            .skipNil().filter { $0.isEmpty }.mapToVoid()
        firstAnswerView.reactive.errors <~ output.validations.firstAnswer
        secondAnswerView.reactive.errors <~ output.validations.secondAnswer
        thirdAnswerView.reactive.errors <~ output.validations.thirdAnswer
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationFourthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == thirdAnswerView.textField {
            DispatchQueue.main.async {
                self.scrollView.scrollToBottom(animated: true)
            }
        }
        return true
    }
}
