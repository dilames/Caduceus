//
//  AutologinUseCase.swift
//  Domain
//
//  Created by Andrew Chersky  on 4/19/18.
//

import Foundation
import ReactiveSwift
import Result

public protocol SessionUseCase {
    var isSessionAlive: Bool { get }
}

public protocol HasSessionUseCase {
    var session: SessionUseCase { get }
}
