//
//  TableViewDelegate.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/4/18.
//

import UIKit

final class TableViewDelegate: NSObject, UITableViewDelegate {
    
    typealias RowHeight = 			(_ indexPath: IndexPath) -> CGFloat
    typealias HeaderFooterHeight = 	(_ section: Int) -> CGFloat
    typealias HeaderFooterView = 	(_ section: Int) -> UIView?
    
    var rowHeight: RowHeight
    var headerView: HeaderFooterView
    var footerView: HeaderFooterView
    var headerHeight: HeaderFooterHeight
    var footerHeight: HeaderFooterHeight
    
    override init() {
        rowHeight = { _ in 0.0 }
        headerView = { _ in nil }
        footerView = { _ in nil }
        headerHeight = { _ in 0.0 }
        footerHeight = { _ in 0.0 }
        super.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView(section)
    }
}
