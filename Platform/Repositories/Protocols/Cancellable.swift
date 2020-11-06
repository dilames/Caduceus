//
//  Cancellable.swift
//  Platform
//
//  Created by Andrew Chersky  on 4/25/18.
//

import Foundation

protocol Cancellable {
    func cancel()
}

final class SimpleCancellable: Cancellable {
    private(set) var isCancelled: Bool = false
    func cancel() {
        isCancelled = true
    }
}

final class CompositeCancellable: Cancellable {
    private(set) var isCancelled: Bool = false
    private var cancellables: [Cancellable] = []
    
    func add(_ cancellable: Cancellable) {
        cancellables.append(cancellable)
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
        isCancelled = true
    }
}

final class BlockCancellable: Cancellable {
    
    typealias CancellableBlock = () -> Void
    typealias CancellableBag = [CancellableBlock]
    
    private var cancellableBag: CancellableBag
    private(set) var isCancelled: Bool = false
    
    init() {
        cancellableBag = []
    }
    
    init(_ block: @escaping CancellableBlock) {
        cancellableBag = []
        cancellableBag.append(block)
    }
    
    init(cancellableBag: CancellableBag) {
        self.cancellableBag = cancellableBag
    }
    
    func add(_ block: @escaping CancellableBlock) {
        cancellableBag.append(block)
    }
    
    static func+=(lhs: inout BlockCancellable, rhs: @escaping CancellableBlock) {
        lhs.add(rhs)
    }
    
    func cancel() {
        cancellableBag.forEach { $0() }
        isCancelled = true
    }
}
