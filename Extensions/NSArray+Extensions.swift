//
//  NSArray+Extensions.swift
//  Extensions
//
//  Created by Andrew Chersky  on 3/6/18.
//

import Foundation

public extension Collection {
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element: Equatable {
    
    /// Remove first collection element that is equal to the given `object`:
    @discardableResult
    public mutating func remove(_ object: Element) -> Element? {
        if let index = index(of: object) {
            return remove(at: index)
        }
        return nil
    }
    
    /// Removes array of elements
    public mutating func remove(contentsOf elements: [Element]) {
        elements.forEach {remove($0)}
    }
    
    public mutating func replace(_ object: Element, with newElement: Element) {
        if let index = index(of: object) {
            self[index] = newElement
        }
    }
    
    public mutating func appendOrReplace(_ object: Element) {
        if let index = index(of: object) {
            self[index] = object
        } else {
            append(object)
        }
    }
    
    public mutating func appendOrReplace(contentsOf elements: [Element]) {
        elements.forEach {appendOrReplace($0)}
    }
}

extension Array {
    public mutating func moveItem(from oldIndex: Index, to newIndex: Index) {
        let removedObject = remove(at: oldIndex)
        insert(removedObject, at: newIndex)
    }
}

extension String {
    public var nilIfEmpty: String? {
        return isEmpty ? nil : self
    }
}
