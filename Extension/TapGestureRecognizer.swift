//
//  TapGestureRecognizer.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/16.
//

import UIKit

private var touchKey = "touchKey"


extension UITapGestureRecognizer {

    
    typealias Touch = (UITapGestureRecognizer) -> Void

    var touch: Touch? {
        set {
            objc_setAssociatedObject(self, &touchKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }

        get {
            return objc_getAssociatedObject(self, &touchKey) as? Touch
        }
    }
    convenience init(_ touch: @escaping Touch) {

        self.init()
        addTarget(self, action: #selector(clickTap))
        self.touch = touch
    }

    @objc func clickTap(gesture: UITapGestureRecognizer) {
        touch?(gesture)
    }

}
