//
//  StepView.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/7/18.
//

import UIKit

final class StepView: UIView {
    
    typealias Handler = (_ step: Int) -> Void
    
    struct Configuration {
        let numberOfSteps: Int
        let cornerRadius: CGFloat
        let padding: CGFloat
        let doneStepsColor: UIColor
        let currentStepColor: UIColor
        let nextStepsColor: UIColor
    }
    
    private let configuration: Configuration
    private var views: [UIView] = []
    private var currentStep = 0
    private var isAnimatingForward: Bool = false
    private var isAnimatingBack: Bool = false
    private var backAnimationCompletion: Handler?
    
    var isLayouted: Bool = false
    
    // MARK: - Lifecycle
    
    init(configuration: Configuration, frame: CGRect = .zero) {
        self.configuration = configuration
        super.init(frame: frame)
        setup()
        configureInitial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isLayouted = true
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = nil
        for index in 0 ..< configuration.numberOfSteps {
            let view = UIView(frame: .zero)
            addSubview(view)
            views.append(view)
            view.backgroundColor = configuration.nextStepsColor
            view.layer.cornerRadius = configuration.cornerRadius
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            let viewWidth = UIScreen.main.bounds.width / CGFloat(configuration.numberOfSteps) -
                configuration.padding
            view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
            if let previousView = views[safe: index - 1], index > 0 {
                view.leftAnchor.constraint(equalTo: previousView.rightAnchor,
                                              constant: configuration.padding).isActive = true
            } else {
                view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            }
        }
    }
    
    private func configureInitial() {
        views[safe: currentStep]?.backgroundColor = configuration.currentStepColor
    }
    
    // MARK: - Update
    
    func setActiveStep(_ activeStep: Int, animated: Bool = false) {
        guard
            views[safe: activeStep] != nil,
            activeStep != currentStep else {
                return
        }
        activeStep > currentStep ?
            moveStepForward(to: activeStep, animated: animated)
            :
            moveStepBack(to: activeStep, animated: animated)
        currentStep = activeStep
    }
    
    func toggleNextStep(animated: Bool = false) {
        setActiveStep(currentStep + 1, animated: animated)
    }
    
    func togglePreviousStep(animated: Bool = false) {
        setActiveStep(currentStep - 1, animated: animated)
    }
    
    private func moveStepForward(to activeStep: Int, animated: Bool = false) {
        if animated {
            if isAnimatingBack {
                backAnimationCompletion = { [weak self] step in
                    self?.currentStep = step
                    self?.setActiveStep(activeStep, animated: animated)
                }
                return
            } else {
                backAnimationCompletion = nil
            }
            isAnimatingForward = true
            let animatingView = UIView(frame: views[currentStep].frame)
            animatingView.backgroundColor = configuration.currentStepColor
            animatingView.layer.cornerRadius = configuration.cornerRadius
            animatingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(animatingView)
            views[currentStep].backgroundColor = configuration.doneStepsColor
            UIView.animate(withDuration: 0.3, animations: {
                animatingView.frame = self.views[activeStep].frame
                let intermediateViews = self.views
                    .enumerated()
                    .filter {$0.offset > self.currentStep && $0.offset < activeStep}
                    .map {$0.element}
                intermediateViews.forEach {$0.backgroundColor = self.configuration.doneStepsColor}
            }, completion: { _ in
                self.isAnimatingForward = false
                if self.isAnimatingBack {
                    return
                }
                self.views[activeStep].backgroundColor = self.configuration.currentStepColor
                animatingView.removeFromSuperview()
            })
        } else {
            views[activeStep].backgroundColor = configuration.currentStepColor
            for index in 0 ..< activeStep {
                views[index].backgroundColor = configuration.doneStepsColor
            }
        }
    }
    
    private func moveStepBack(to activeStep: Int, animated: Bool = false) {
        if animated {
            isAnimatingBack = true
            let animatingView = UIView(frame: views[currentStep].frame)
            animatingView.backgroundColor = configuration.currentStepColor
            animatingView.layer.cornerRadius = configuration.cornerRadius
            animatingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(animatingView)
            views[currentStep].backgroundColor = configuration.nextStepsColor
            UIView.animate(withDuration: 0.3, animations: {
                animatingView.frame = self.views[activeStep].frame
                let intermediateViews = self.views
                	.enumerated()
                    .filter {$0.offset > self.currentStep && $0.offset < activeStep}
                    .map {$0.element}
                intermediateViews.forEach {$0.backgroundColor = self.configuration.nextStepsColor}
            }, completion: { _ in
                self.isAnimatingBack = false
                self.views[activeStep].backgroundColor = self.configuration.currentStepColor
                animatingView.removeFromSuperview()
                self.backAnimationCompletion?(activeStep)
            })
        } else {
            views[activeStep].backgroundColor = configuration.currentStepColor
            for index in activeStep + 1 ..< views.count {
                views[index].backgroundColor = configuration.nextStepsColor
            }
        }
    }
}
