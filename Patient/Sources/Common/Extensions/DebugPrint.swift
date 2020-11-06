//
//  DebugPrint.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/12/18.
//

import Foundation

public func readablePrint(
    _ function: Selector,
    of object: Any,
    transformed transform: ((String) -> String) = { message in message })
{
    let typeName = "\(type(of: object))"
    let printString = "\(typeName): \(function)"
    let transformedString = transform(printString)
    print(transformedString)
}
