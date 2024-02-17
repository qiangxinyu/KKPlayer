//
//  View.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit





class View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    convenience init() {
        self.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSelf()
    }
    
    func initSelf() {}
}





