//
//  SecretQuestionsRowType.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/8/18.
//

import UIKit

// MARK: - Types
enum SecretQuestionsSectionType {
    case input
    case suggestions
}

enum SecretQuestionViewModelType: AutoEquatable {
    case input(SuggestionsInputCellViewModel)
    case suggestion(SuggestionsCellViewModel)
}

struct SecretQuestionsItemType: AutoEquatable {
    let sectionType: SecretQuestionsSectionType
    var viewModels: [SecretQuestionViewModelType]
}

// MARK: - UI
extension SecretQuestionsSectionType {
    typealias Header = (view: UIView?, height: CGFloat)
    
    var index: Int {
        switch self {
        case .input:
            return 0
        case .suggestions:
             return 1
        }
    }
    
    var header: Header {
        switch self {
        case .input:
            return (view: nil, height: 20.0)
        default:
            return (
                view: CommonHeaderView.instantiateFromNib(
                    text: R.string.localizable.enterQuestion(),
                    textColor: .fadedBlue,
                    textFont: .systemFont(ofSize: 15),
                    labelInsets: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0),
                    textAlignment: .left
                ),
                height: 30.0
            )
        }
    }
    
    var footer: Header {
        switch self {
        case .input:
            return (view: nil, height: 15.0)
        case .suggestions:
            return (view: nil, height: 30.0)
        }
    }
}

extension SecretQuestionViewModelType {
    var rowHeight: CGFloat {
        switch self {
        case .input:
            return 70
        case .suggestion:
            return 54
        }
    }
}
