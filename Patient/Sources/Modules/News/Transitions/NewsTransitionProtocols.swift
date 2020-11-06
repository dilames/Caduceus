//
//  NewsTransitionProtocols.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/6/18.
//

import UIKit

protocol NewsTransitionSourceController {
    var collectionView: UICollectionView! { get set }
    var selectedIndexPath: IndexPath? { get set }
}

protocol NewsTransitionDestinationController {
    func prepareForTransition(previewHeight: CGFloat)
    func animateToPresentingFinishState(with duration: TimeInterval, layouting: Bool)
    func animateToDismissingFinishState(with duration: TimeInterval,
                                        previewHeight: CGFloat,
                                        previewCornerRadius: CGFloat,
                                        layouting: Bool)
    var resultViewFrame: CGRect { get }
}

protocol NewsTransitionSourceView {
    var viewCornerRadius: CGFloat { get }
}
