//
//  CustomTypeliases.swift
//  Patient
//
//  Created by Andrew Chersky  on 2/21/18.
//

import Foundation
import ReactiveSwift
import Result

typealias ActionHandler = Action<Void, Void, Never>
typealias SignalTrigger = Signal<Void, Never>
typealias ProducerTrigger = SignalProducer<Void, Never>
