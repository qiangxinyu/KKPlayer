//
//  View.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit


class Label: UILabel {
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


class MainThemeLabel: Label {
    override func initSelf() {
        textColor = .Main
        
        MainColorChange {[weak self] in
            self?.textColor = .Main
        }
    }
}



