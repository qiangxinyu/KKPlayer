//
//  String.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/3.
//

import Foundation

extension String {
    var firstString: String {
        get { subString(start: 0, end: 1)}
    }
    /// 字符串截取
    /// - Parameter start: 起始位置  默认开头
    /// - Parameter end: 结束位置  默认结尾
    func subString(start s: Int = 0, end e: Int = -1) -> String {
        var e = e
        if e < 0 {
            e = count
        }
        
        if e <= s {
            return ""
        }
        
        // 计算结束位置
        e = count - e
        
        if s >= count || e >= count {
            return ""
        }
        
        let start = index(startIndex, offsetBy: s)
        let end = index(endIndex, offsetBy: -e)
        return String(self[start..<end])
    }
    
    /// HEX 获取  RGB 0 - 255
    func getRGB() -> (Int, Int, Int) {
        if let color = Int(self, radix: 16) {
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            return (r, g, b)
        }
        return (0, 0, 0)
    }
    
    /// RGB -> HEX
    static func getHex(_ r: Int, _ g: Int, _ b: Int) -> String {
        return String(format: "%02lX%02lX%02lX", r, g, b)
    }
    /// RGB -> HEX
    static func getHex(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> String {
        return String(format: "%02lX%02lX%02lX", Int(r), Int(g), Int(b))
    }
    
 
    func isLetters() -> Bool {
        return validate(regular: "[A-Z]")
    }
   
    func validate(regular expression: String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@" , expression)
        return predicate.evaluate(with: self)
    }
    
    /// 否含表情
    ///
    ///
    /// - Returns: 是否含表情
    func hasEmoji() -> Bool {
        return !validate(regular: "[\\p{P}\\p{Sm}\\p{Sc}\\p{Sk}➋➌➍➎➏➐➑➒\\w\\u4e00-\\u9fa5\\s\\-]*")
    }
    
    
    func toCGFloat() -> CGFloat {
        return CGFloat(Float(self) ?? 0)
    }
    
    
    var isTurn: Bool {
        get { validate(regular: "[a-z]|[A-Z]|[0-9]|[\\u4e00-\\u9fa5]") }
    }
  
    
    func toPinyin() -> String {
        if count == 0 {
            return self
        }
        
        let first = self.subString(start: 0, end: 1)
        if !first.isTurn {
            return self
        }
        
        let mString = NSMutableString(string: self)
        CFStringTransform(mString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mString, nil, kCFStringTransformStripDiacritics, false)
        let string = NSString(string: mString)
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    
    func removeMP3() -> String {
        if hasSuffix(".mp3") {
            return subString(start: 0, end: count - 4)
        } else {
            return self
        }
    }
   
    func removeErrorText() -> String {
        return replacingOccurrences(of: "\"", with: "'")
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: "\0", with: "")
            .replacingOccurrences(of: "\\", with: "")
    }
    
    
    
    var sortKey: String {
        get {
            var key = subString(end: 1).uppercased()
            if !key.isLetters() || key == "" {
                key = "#"
            }
            return key
        }
    }
}
