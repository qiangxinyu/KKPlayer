//
//  CountHeaderView.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/3/1.
//

import UIKit

class CountHeaderView: Label {
    
    var countString: String = "歌曲数"
    
    var count: Int = 0 {
        didSet {  text = "\(countString)：\(count)" }
    }
    
    override func initSelf() {
        height = 30
        textColor = .T02
        font = .pingFang(size: 12)
    }
   

    open override func drawText(in rect: CGRect) {
        super.drawText(
            in: rect.inset(
                by: .init(
                    top: 0,
                    left: Theme.marginOffset,
                    bottom: 0,
                    right: 0)
            )
        )
    }
}

