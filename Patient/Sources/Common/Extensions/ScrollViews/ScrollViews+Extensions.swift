//
//  ScrollViews+Extensions.swift
//  LetsSurf
//
//  Created by Vlad Kuznetsov on 1/30/18.
//  Copyright © 2018 Cleveroad Inc. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib<T>(for cellClass: T.Type) where T: UITableViewCell {
        let identifier = String(describing: cellClass)
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerNib<T>(for cellClass: T.Type) where T: UIView {
        let identifier = String(describing: cellClass)
        register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerNibs<T>(for cellClasses: [T.Type]) where T: UITableViewCell {
        cellClasses.forEach { self.registerNib(for: $0) }
    }
    
    func registerNibs<T>(for cellClasses: [T.Type]) where T: UIView {
        cellClasses.forEach { self.registerNib(for: $0) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as? T {
            return cell
        }
        fatalError("Unable to dequeue cell \(cellClass)")
    }
    
    func dequeueReusableHeaderFooterView<T: UIView>(cellClass: T.Type) -> T {
        if let cell =  dequeueReusableHeaderFooterView(withIdentifier: String(describing: cellClass)) as? T {
            return cell
        }
        fatalError("Unable to dequeue cell \(cellClass)")
    }
}

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(for cellClass: T.Type) {
        let identifier = String(describing: cellClass)
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func registerNib<T>(for cellClass: T.Type, forSupplementaryViewOfKind kind: SupplementaryViewKind) where T: UIView {
        let identifier = String(describing: cellClass)
        register(UINib(nibName: identifier, bundle: nil),
                 forSupplementaryViewOfKind: kind.stringValue,
                 withReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        if let cell =  dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as? T {
            return cell
        }
        fatalError("Unable to dequeue cell \(cellClass)")
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        viewClass: T.Type,
        ofKind kind: SupplementaryViewKind,
        for indexPath: IndexPath) -> T
    {
        let identifier = String(describing: viewClass)
        if let view = dequeueReusableSupplementaryView(
            ofKind: kind.stringValue,
            withReuseIdentifier: identifier,
            for: indexPath) as? T
        {
            return view
        }
        fatalError("Unable to dequeue view \(viewClass)")
    }
}

enum SupplementaryViewKind {
    case header
    case footer
    
    var stringValue: String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
        case .footer:
            return UICollectionElementKindSectionFooter
        }
    }
}
