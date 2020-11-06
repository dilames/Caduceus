//
//  MarkNewsView.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/7/18.
//

import UIKit

class MarkNewsView: UIView {

    enum State {
        case marked
        case notMarked
        case updating
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markButton: IndicatedButton!
    
    var state: State = .notMarked {
        didSet {
            updateView(with: state)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        markButton.addTarget(self, action: #selector(testButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        state = .notMarked
        markButton.activityStyle = state == .notMarked ? .gray : .white
        layer.cornerRadius = 15.0
    }
    
    private func updateView(with state: State) {
        switch state {
        case .marked:
            markButton.stopIndicating()
            markButton.activityStyle = .white
            titleLabel.text = R.string.localizable.markedNewsTitle()
            markButton.setTitle(R.string.localizable.marked(), for: .normal)
            markButton.backgroundColor = .cornflowerBlue
            markButton.setTitleColor(.white, for: .normal)
        case .notMarked:
            markButton.stopIndicating()
            markButton.activityStyle = .gray
            titleLabel.text = R.string.localizable.notMarkedNewsTitle()
            markButton.setTitle(R.string.localizable.mark(), for: .normal)
            markButton.backgroundColor = .white98
            markButton.setTitleColor(.steelTwo, for: .normal)
        case .updating:
            markButton.setImage(nil, for: .normal)
            markButton.startIndicating()
        }
    }
    
    @objc private func testButton() {
        switch state {
        case .marked:
            state = .updating
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.state = .notMarked
            }
        case .notMarked:
            state = .updating
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.state = .marked
            }
        default:
            break
        }
    }
}
