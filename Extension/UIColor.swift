//
//  Color.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/3.
//

import UIKit

extension UIColor {
    static let T01 = UIColor(named: "T01")!
    static let T02 = UIColor(named: "T02")!

    
    static let B01 = UIColor(named: "B01")!
    static let B02 = UIColor(named: "B02")!
    static let B03 = UIColor(named: "B03")!
    static let B04 = UIColor(named: "B04")!

    static let P01 = UIColor(named: "P01")!
    static let P02 = UIColor(named: "P02")!
    
    static var Main = UIColor.HEXA("E91E63")
//    static var Main = UIColor.HEXA(UserDefaultsUtils.themeColor[0])

    
    /// 获取颜色
    /// - Parameters:
    ///   - r: 0 - 255
    ///   - g: 0 - 255
    ///   - b: 0 - 255
    ///   - a: 0 - 1
    class func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    /// 获取颜色
    /// - Parameters:
    ///   - r: 0 - 255
    ///   - g: 0 - 255
    ///   - b: 0 - 255
    ///   - a: 0 - 1
    class func RGBA(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
    
    /// 获取颜色
    /// - Parameters:
    ///   - hex: #FFFFFF 或者 FFFFFF 格式的颜色
    ///   - a: 透明度 0 ~ 1
    class func HEXA(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        var hex = hex
        if hex.hasPrefix("#") {
            hex = hex.subString(start: 1)
        }
        let (r, g, b) = hex.getRGB()
        return RGBA(r, g, b, alpha)
    }
    
   
    
  
}
