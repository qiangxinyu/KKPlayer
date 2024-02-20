//
//  TapProtocol.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/16.
//

import UIKit


public protocol TapProtocol: UIView {}
extension TapProtocol {
    public func touchUpInside(touch: @escaping () -> Void) {
        addGestureRecognizer(UITapGestureRecognizer {_ in
            touch()
        })
    }
    
    func touchUpInside(touch: @escaping UIGestureRecognizer.Touch) {
        addGestureRecognizer(UITapGestureRecognizer(touch))
    }
}



protocol PanProtocol: UIView {}
extension PanProtocol {
    func pan(touch: @escaping UIGestureRecognizer.Touch) {
        addGestureRecognizer(UIPanGestureRecognizer(touch))
    }
}

