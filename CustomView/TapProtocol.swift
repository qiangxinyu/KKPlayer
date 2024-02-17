//
//  TapProtocol.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/16.
//

import UIKit


protocol TapProtocol: UIView {
    
}

extension TapProtocol {
    func touchUpInside(touch: @escaping UITapGestureRecognizer.Touch) {
        addGestureRecognizer(UITapGestureRecognizer(touch))
    }
}


