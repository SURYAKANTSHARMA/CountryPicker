//
//  TableViewHelpers.swift
//  QuizApp
//
//  Created by SuryaKant Sharma on 13/12/20.
//

import UIKit

extension UITableView {
    func cell(at index: Int) -> UITableViewCell? {
        dataSource?.tableView(self, cellForRowAt: IndexPath(row: index, section: 0))
    }
    
    func title(at row: Int) -> String? {
        cell(at: row)?.textLabel?.text
    }
    
    func select(row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        self.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deSelect(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        self.deselectRow(at: indexPath, animated: false)
        self.delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
}
