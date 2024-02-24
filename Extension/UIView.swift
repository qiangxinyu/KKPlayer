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
    
    var centerX: CGFloat {
        set {
            x = newValue * 2 - width
        }
        get {
            (width - x) / 2 + x
        }
    }
    
    var centerY: CGFloat {
        set {
            y = newValue * 2 - height
        }
        get {
            (height - y) / 2 + y
        }
    }
    
    
    
    static var presentLine: UIView {
        let v = UIView()
        v.layer.cornerRadius = 3
        v.backgroundColor = .B04
        v.frame = .init(x: 0, y: 0, width: 60, height: 6)
        return v
    }
}




extension UIView {
    
    /// 设置渐变背景色
    /// - Parameters:
    ///   - hexs: 颜色数组  [#FFFFFF00]
    ///   - mode: 渐变模式
    ///   - frame: 想要的frame  默认自身bounds
    ///   - cornerRadius: 圆角
    func settingGradientColor(
        hexas: [String],
        mode: ColorMode,
        frame: CGRect? = nil,
        cornerRadius: CGFloat? = nil)
    {
        settingGradientColor(colors: hexas.map { .HEXA($0) }, mode: mode, frame: frame, cornerRadius: cornerRadius)
    }
    
    /// 设置渐变背景色
    /// - Parameters:
    ///   - hexs: 颜色数组  [#FFFFFF]
    ///   - mode: 渐变模式
    ///   - frame: 想要的frame  默认自身bounds
    ///   - cornerRadius: 圆角
    func settingGradientColor(
        hexs: [String],
        mode: ColorMode,
        frame: CGRect? = nil,
        cornerRadius: CGFloat? = nil)
    {
        settingGradientColor(colors: hexs.map { .HEX($0) }, mode: mode, frame: frame, cornerRadius: cornerRadius)
    }
    
    /// 设置渐变背景色
    /// - Parameters:
    ///   - colors: 颜色数组  >= 1
    ///   - mode: 渐变模式
    ///   - frame: 想要的frame  默认自身bounds
    ///   - cornerRadius: 圆角
    func settingGradientColor(
        colors: [UIColor],
        mode: ColorMode,
        frame: CGRect? = nil,
        cornerRadius: CGFloat? = nil)
    {
        let layer = CAGradientLayer()

        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
        
        layer.frame = frame ?? bounds
        var cgColors = colors.map { $0.cgColor }
        
        let (start, end) = mode.gradientPoint

        layer.startPoint = start
        layer.endPoint = end
        
        if mode == .toInside {
            cgColors.reverse()
            layer.type = .radial
        } else if mode == .toOutside {
            layer.type = .radial
        }
          
        layer.colors = cgColors
        self.layer.insertSublayer(layer, at: 0)
    }
}



// 颜色类型
enum ColorMode: Int {
    case `default`
    case toRight //从左到右渐变
    case toLeft //从右到左渐变
    case toBottom //从上到下渐变
    case toTop //从下到上渐变
    case toOutside //从内向外渐变
    case toInside //从外向内渐变
    case toRightBottom //左上到右下
    case toRightTop //左下到右上
    case toLeftBottom //右上到左下
    case toLeftTop //右下到左上
    
    
    var gradientPoint: (CGPoint, CGPoint) {
        switch self {
        case .toTop, .default:
            return (.init(x: 0, y: 1), .init(x: 0, y: 0))
        case .toRight:
            return (.init(x: 0, y: 0), .init(x: 1, y: 0))
        case .toLeft:
            return (.init(x: 1, y: 1), .init(x: 0, y: 0))
        case .toBottom:
            return (.init(x: 0, y: 0), .init(x: 0, y: 1))
        case .toRightTop:
            return (.init(x: 0, y: 1), .init(x: 1, y: 0))
        case .toRightBottom:
            return (.init(x: 0, y: 0), .init(x: 1, y: 1))
        case .toLeftTop:
            return (.init(x: 1, y: 1), .init(x: 0, y: 0))
        case .toLeftBottom:
            return (.init(x: 1, y: 0), .init(x: 0, y: 1))
        case .toInside, .toOutside:
            return (.init(x: 0.5, y: 0.5), .init(x: 1, y: 1))
        }
    }
}
