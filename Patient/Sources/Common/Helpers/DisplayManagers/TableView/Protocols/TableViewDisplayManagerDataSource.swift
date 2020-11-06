//
//  TableViewDisplayManagerDataSource.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/14/18.
//

import UIKit

protocol TableViewDisplayManagerDataSource: class {
    
    typealias DisplayManager = UITableViewDataSource & UITableViewDelegate
    
    func displayManager(_ displayManager: DisplayManager,
                        heightForRowAt indexPath: IndexPath) -> CGFloat
    
    func displayManager(_ displayManager: DisplayManager,
                        heightForHeaderIn section: Int) -> CGFloat
    
    func displayManager(_ displayManager: DisplayManager,
                        heightForFooterIn section: Int) -> CGFloat
    
}

extension TableViewDisplayManagerDataSource {
    func displayManager(_ displayManager: DisplayManager,
                        heightForHeaderIn section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func displayManager(_ displayManager: DisplayManager,
                        heightForFooterIn section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
