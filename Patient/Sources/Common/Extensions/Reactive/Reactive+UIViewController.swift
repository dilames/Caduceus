//
//  Reactive+UIViewController.swift
//  Order
//
//  Created by Ihor Teltov on 1/2/18.
//  Copyright © 2018 Ihor Teltov. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import Result

public extension Reactive where Base: UIViewController {
    
    public var viewDidLoad: Signal<Void, Never> {
        return trigger(for: #selector(Base.viewDidLoad))
    }
    
    public var viewWillAppear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewWillAppear(_:)))
            .map { $0.first as! Bool /* swiftlint:disable:this force_cast */ }
    }
    
    public var viewDidAppear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewDidAppear(_:)))
            .map { $0.first as! Bool /* swiftlint:disable:this force_cast */ }
    }
    
    public var viewWillDisappear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewWillDisappear(_:)))
            .map { $0.first as! Bool /* swiftlint:disable:this force_cast */ }
    }
    
    public var viewDidDisappear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewDidDisappear(_:)))
            .map { $0.first as! Bool /* swiftlint:disable:this force_cast */ }
    }
    
    public var viewWillLayoutSubviews: Signal<Void, Never> {
        return trigger(for: #selector(Base.viewWillLayoutSubviews))
    }
    
    public var viewDidLayoutSubviews: Signal<Void, Never> {
        return trigger(for: #selector(Base.viewDidLayoutSubviews))
    }
    
    public var didReceiveMemoryWarning: Signal<Void, Never> {
        return trigger(for: #selector(Base.didReceiveMemoryWarning))
    }
    
    public var isActive: Signal<Bool, Never> {
        return Signal.merge(viewDidAppear.map { _ in true },
                            viewWillDisappear.map { _ in false })
    }
    
    public var isVisible: Signal<Bool, Never> {
        return Signal.merge(viewWillAppear.map { _ in true },
                            viewDidDisappear.map { _ in false })
    }
    
}
