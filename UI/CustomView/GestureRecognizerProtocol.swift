//
//  TapProtocol.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/16.
//

import UIKit


@MainActor public protocol TapProtocol: UIView , UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    
}
extension TapProtocol  {
    public func touchUpInside(touch: @escaping () -> Void) {
        let tap = UITapGestureRecognizer {_ in
            touch()
        }
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    func touchUpInside(touch: @escaping UIGestureRecognizer.Touch) {
        let tap = UITapGestureRecognizer(touch)
        tap.delegate = self
        addGestureRecognizer(tap)
    }
}



protocol PanProtocol: UIView {}
extension PanProtocol {
    func pan(touch: @escaping UIGestureRecognizer.Touch) {
        addGestureRecognizer(UIPanGestureRecognizer(touch))
    }
}

