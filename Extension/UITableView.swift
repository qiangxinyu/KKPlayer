//
//  UITableView.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/19.
//

import UIKit

extension UITableView {
    func scrollTo<T: Equatable>(item: T?, list: [T], postion: UITableView.ScrollPosition = .middle) {
        
        guard let model = item,
              let index = list.firstIndex(of: model),
                numberOfRows(inSection: 0) > index else {return}
        
        scrollToRow(at: .init(row: index, section: 0), at: .middle, animated: true)
    }
}
