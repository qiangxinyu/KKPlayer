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
    
    static var Main = UIColor.HEXA(UserDefaultsUtils.themeColor[0])

    
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
    class func HEX(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        var hex = hex
        if hex.hasPrefix("#") {
            hex = hex.subString(start: 1)
        }
        let (r, g, b) = hex.toRGB()
        return RGBA(r, g, b, alpha)
    }
    
    /// 获取颜色 #FFFFFFFF
    /// - Parameters:
    ///   - hex: #FFFFFFFF 或者 FFFFFF00 格式的颜色  带透明度
    class func HEXA(_ hex: String) -> UIColor {
        var hex = hex
        if hex.hasPrefix("#") {
            hex = hex.subString(start: 1)
        }
        let (r, g, b, a) = hex.toRGBA()
        
        return RGBA(r, g, b, CGFloat(a) / 255)
    }
  
    var HEXA: String {
        
        let (r, g, b, a) = RGBA
        
        let HEX_R = Int(r * 255)
        let HEX_G = Int(g * 255)
        let HEX_B = Int(b * 255)
        let HEX_A = Int(a * 255)
        
        return String(format: "#%02X%02X%02X%02X", HEX_R, HEX_G, HEX_B, HEX_A)
    }
    
    
    /// 0 - 1
    var RGBA: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    var HSBA: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
}



typealias MainColorChnageBlock = () -> Void
private var MainColorChnageBlocks = [MainColorChnageBlock?]()

func MainColorChange(_ block: MainColorChnageBlock?) {
    MainColorChnageBlocks = MainColorChnageBlocks.filter { $0 != nil }
    MainColorChnageBlocks.append(block)
}
func PostMainColorChnage() {
    MainColorChnageBlocks.forEach {$0?()}
}
