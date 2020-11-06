//
//  MaskedInput.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/4/18.
//

import Foundation

protocol MaskedInputDataSource: class {
    func maskedInputText(_ maskedInput: MaskedInput) -> String
}

protocol MaskedInputDelegate: class {
    func maskedInput(_ maskedInput: MaskedInput, didTransformInputTo output: String)
}

final class MaskedInput {
    
    let format: String
    
    weak var dataSource: MaskedInputDataSource?
    weak var delegate: MaskedInputDelegate?
    
    private var digitsSet: String {
        return "0123456789"
    }
    
    private var text: String {
        return dataSource?.maskedInputText(self) ?? ""
    }
    
    init(format: String) {
        self.format = format
    }
    
    @objc func applyTransform() {
        transform(text: text)
    }
    
    private func transform(text: String) {
        let digits = digitsCharacters(from: text)
        if digits.isEmpty {
            delegate?.maskedInput(self, didTransformInputTo: "")
            return
        }
        let format = digits.reduce(into: self.format) { (string, digit) in
            if let index = string.index(where: { $0 == digit }) {
                string.replace("*", at: index)
            }
        }
        let result = digits.reduce(into: format) { (string, digit) in
            if let index = string.index(where: { $0 == Character("*") }) {
                string.replace(digit, at: index)
            }
        }
        let output = stringRemovingEmptyMask(from: result)
        delegate?.maskedInput(self, didTransformInputTo: output)
    }
    
    private func digitsCharacters(from string: String) -> [Character] {
        return string.filter({ digitsSet.contains($0) })
    }
    
    private func stringRemovingEmptyMask(from string: String) -> String {
        if let index = string.reversed().index(where: { digitsSet.contains($0) })?.base {
            var resultString = string
            resultString.removeSubrange((index ..< string.endIndex))
            if resultString.isEmpty { resultString.removeAll() }
            return resultString
        }
        return string
    }
}

private extension String {
    @discardableResult mutating func replace(_ character: Character, at selectedIndex: Index) -> Character {
        insert(character, at: selectedIndex)
        return remove(at: index(after: selectedIndex))
    }
}

extension MaskedInput {
    enum MaskType {
        case ukrainianPhoneNumber
        case ukrainianPrefilledPhoneNumber
        case custom(String)
        
        var format: String {
            switch self {
            case .ukrainianPhoneNumber:
                return "+(***)**-***-**-**"
            case .ukrainianPrefilledPhoneNumber:
                return "+(380)**-***-**-**"
            case .custom(let format):
                return format
            }
        }
    }
}
