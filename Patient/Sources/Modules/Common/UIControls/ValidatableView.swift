//
//  ValidatableView.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/26/18.
//

import UIKit
import ReactiveSwift
import Result

@IBDesignable final class ValidatableView: UIView {
    
    // MARK: - Variables
    
    private(set) lazy var textField: UITextField = setupTextField()
    private(set) lazy var errorLabel: UILabel = setupErrorLabel()
    
    private var textFieldBottom: NSLayoutConstraint?
    fileprivate let mutableErrors: MutableProperty<[Error]> = .init([])
    
    // MARK: - IBInspectables
    
    @IBInspectable var text: String = "" {
        didSet {
            textField.text = text
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var clearButton: UIImage? {
        didSet {
            textField.clearButton = clearButton
        }
    }
    
    @IBInspectable var shouldClearErrorsOnEditing: Bool = true
    
    // MARK: - Observable variables
    
    var errors: [Error] = [] {
        didSet {
            mutableErrors.value = errors
            update(with: errors)
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonSetup()
    }
    
    private func commonSetup() {
         _ = textField
        _ = errorLabel
        textField.text = ""
        textField.sendActions(for: .editingChanged)
        backgroundColor = nil
        clipsToBounds = true
        bindComponents()
    }
    
    private func bindComponents() {
        if shouldClearErrorsOnEditing {
            let editingStarted = textField.reactive.controlEvents(.editingDidBegin).mapToVoid()
            let editingChanged = textField.reactive.controlEvents(.editingChanged).mapToVoid()
            let textValues = textField.reactive.continuousTextValues.mapToVoid()
            let textValuesOnEditingChanged = Signal
                .zip(editingChanged, textValues)
                .mapToVoid()
            Signal
                .merge(editingStarted, textValuesOnEditingChanged)
                .observeValues { self.update(with: []) }
        }
    }
    
    // MARK: - Setup
    
    private func setupTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textField.textColor = .cornflowerBlue
        textField.tintColor = .cornflowerBlue
        addSubview(textField)
        let constraints = textField.constrain(to: self)
        textFieldBottom = constraints.bottom
        layoutIfNeeded()
        return textField
    }
    
    private func setupErrorLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .red
        label.numberOfLines = 2
        label.alpha = 0.0
        addSubview(label)
        label.constrain(toViewFromBelow: self, bottomInset: 8)
        layoutIfNeeded()
        return label
    }
    
    private func update(with errors: [Error]) {
        let setErrorText = {
            self.errorLabel.text = errors
                .map { $0.localizedDescription }
                .joined(separator: ", ")
            self.layoutIfNeeded()
        }
        if !errors.isEmpty {
            setErrorText()
        } else {
            self.layoutIfNeeded()
        }
        textFieldBottom?.constant = errors.isEmpty ? 0.0 : -errorLabel.bounds.height
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = errors.isEmpty ? 0.0 : 1.0
            self.layoutIfNeeded()
        }, completion: { _ in
            if errors.isEmpty {
                setErrorText()
            }
        })
    }
}

// MARK: - UI Reactive Bindings
extension Reactive where Base: ValidatableView {
    var text: BindingTarget<String> {
        return base.reactive.text
    }
    
    var errors: BindingTarget<[Error]> {
        return makeBindingTarget {
            $0.errors = $1
        }
    }
    
    var continuousTextValues: Signal<String, Never> {
        return base.textField.reactive.continuousTextValues
    }
    
    var continuousErrorValues: Signal<[Error], Never> {
        return base.mutableErrors.signal
    }
}
