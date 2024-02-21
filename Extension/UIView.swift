//
//  UIView.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//


import UIKit

extension UIView {
    var width: CGFloat {
        set {
            frame.also { $0.size.width = newValue }
        }
        get { frame.size.width }
    }
    
    var height: CGFloat {
        set {
            frame.also { $0.size.height = newValue }
        }
        get { frame.size.height }
    }
    
    var x: CGFloat {
        set {
            frame.also { $0.origin.x = newValue }
        }
        get { frame.origin.x }
    }
    
    var y: CGFloat {
        set {
            frame.also { $0.origin.y = newValue }
        }
        get { frame.origin.y }
    }
    
    
    static var presentLine: UIView {
        let v = UIView()
        v.layer.cornerRadius = 3
        v.backgroundColor = .B04
        v.frame = .init(x: 0, y: 0, width: 60, height: 6)
        return v
    }
}


