//
//  NSObject+Association.swift
//  Extensions
//
//  Created by Andrew Chersky  on 2/19/18.
//

import Foundation

public enum AssociationPolicy {
    case assign
    case retainNonatomic
    case copyNonatomic
    case retain
    case copy
    
    fileprivate var rawValue: objc_AssociationPolicy {
        switch self {
        case .assign:
            return .OBJC_ASSOCIATION_ASSIGN
        case .retainNonatomic:
            return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copyNonatomic:
            return .OBJC_ASSOCIATION_COPY_NONATOMIC
        case .retain:
            return .OBJC_ASSOCIATION_RETAIN
        case .copy:
            return .OBJC_ASSOCIATION_COPY
        }
    }
}

public extension NSObject {
    
    public func setAssociatedObject<T>(value: T, key: UnsafeRawPointer, policy: AssociationPolicy) {
        objc_setAssociatedObject(self, key, value as AnyObject, policy.rawValue)
    }
    
    public func getAssociatedObject<T>(key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    
    public func removeAssociatedObject(key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, nil, AssociationPolicy.retain.rawValue)
    }
    
}
