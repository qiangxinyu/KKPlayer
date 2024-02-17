//
//  Font.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/3.
//

import UIKit

extension UIFont {
    enum PingFangSC: String {
        case regular = "PingFangSC-Regular"
        case light = "PingFangSC-Light"
        case medium = "PingFangSC-Medium"
        case semibold = "PingFangSC-Semibold"
    }
 
    
    
    /// 获取苹方字体
    /// - Parameters:
    ///   - name: 默认 regular
    ///   - size: size

    static func pingFang(name: PingFangSC = .regular, size: CGFloat) -> UIFont {
        return .init(name: name.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}

