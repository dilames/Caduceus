//
//  UIScrollView+KeyboardChanges.swift
//  LetsSurf
//
//  Created by Andrew Chersky  on 1/29/18.
//  Copyright © 2018 Cleveroad Inc. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UIScrollView {
    func adjustInsetsOnKeyboardNotification(extraBottomInset: CGFloat = 0.0, scrollingToBottom: Bool = false) {
        NotificationCenter.default.reactive.keyboardChange
            .take(during: reactive.lifetime)
            .observe(on: UIScheduler())
            .observeValues { [weak self] context in
                guard let `self` = self else { return }
                UIView.animate(withDuration: context.animationDuration, animations: {
                    self.contentInset.bottom = UIScreen.main.bounds.height - context.endFrame.origin.y - extraBottomInset
                    self.scrollIndicatorInsets.bottom = self.contentInset.bottom
                })
        }
        if scrollingToBottom {
            NotificationCenter.default.reactive
                .notifications(forName: .UIKeyboardWillShow)
                .take(during: reactive.lifetime)
                .observeValues { [weak self] notification in
                    guard let strongSelf = self else { return }
                    if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                        let yOffset = strongSelf.contentSize.height - strongSelf.bounds.height + strongSelf.contentInset.bottom
                        let offset = CGPoint(x: strongSelf.contentOffset.x, y: yOffset)
                        UIView.animate(withDuration: TimeInterval(duration), animations: {
                            strongSelf.setContentOffset(offset, animated: false)
                        })
                    }
            }
        }
    }
    
    func scrollToBottom(animated: Bool = false) {
        let yOffset = contentSize.height - bounds.height + contentInset.bottom
        let offset = CGPoint(x: contentOffset.x, y: yOffset)
        UIView.animate(withDuration: animated ?  0.3 : 0.0) {
            self.setContentOffset(offset, animated: false)
        }
    }
}
