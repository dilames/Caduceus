//
//  StepNavigationController.swift
//  Patient
//
//  Created by Andrew Chersky  on 3/7/18.
//

import UIKit

final class StepNavigationController: BaseNavigationController {

    // MARK: - Variables
    
    var numberOfSteps: Int?
    private lazy var stepView: StepView = self.setupStepView()
    
    // MARK: - Lifecycle
    
    init(shouldRoundCorners: Bool) {
        super.init(nibName: nil, bundle: nil)
        if shouldRoundCorners {
            modalPresentationStyle = .custom
            transitioningDelegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - Public
    
    func showStepView(animated: Bool = false) {
        _ = stepView
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.stepView.alpha = 1.0
        }
    }
    
    func hideStepView(animated: Bool = false) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.stepView.alpha = 0.0
        }
    }
    
    func toggleNextStep() {
        stepView.toggleNextStep(animated: true)
    }
    
    func togglePreviousStep() {
        stepView.togglePreviousStep(animated: true)
    }
    
    func setStepIndex(_ step: Int) {
        stepView.setActiveStep(step, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationBar.shadowImage = UIImage()
    }
    
    private func setupStepView() -> StepView {
        let stepView = StepView(configuration: defaultStepViewConfiguration())
        stepView.alpha = 0.0
        navigationBar.addSubview(stepView)
        stepView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            stepView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            stepView.heightAnchor.constraint(equalToConstant: 5)]
        )
        stepView.layoutIfNeeded()
        return stepView
    }
    
    private func defaultStepViewConfiguration() -> StepView.Configuration {
        let height: CGFloat = 5.0
        return StepView.Configuration(
            numberOfSteps: numberOfSteps ?? 0,
            cornerRadius: height / 2,
            padding: 0.5,
            doneStepsColor: .darkSlateBlue,
            currentStepColor: .cornflowerBlue,
            nextStepsColor: .pinkishGray
        )
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension StepNavigationController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController)
        -> UIPresentationController?
    {
        let topPadding = UIApplication.shared.statusBarFrame.height
        let options = DimmingPresentationController.Options(
            shouldDimPresentingController: true,
            shouldReducePresentingController: false,
            cornerRadiusOfPresentingController: 0.0,
            cornerRadiusOfPresentedController: 15.0,
            shadowAlpha: 0.7
        )
        let insets = DimmingPresentationController.Insets(dxLength: 0.0, dyLength: topPadding / 2)
        let offset = DimmingPresentationController.Insets(dxLength: 0.0, dyLength: topPadding / 2)
        return DimmingPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            options: options,
            insets: insets,
            offset: offset
        )
    }
}
