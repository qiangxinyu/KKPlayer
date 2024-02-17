//
//  Notification.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/3.
//

import Foundation

class UserDefaultsUtils {
    private static let userDefault = UserDefaults.standard
    
    static func synchronize() {
        userDefault.synchronize()
    }
    
    
    private static let idKey = "idKey"
    static var id: Int64 {
        set {
            userDefault.set(newValue, forKey: idKey)
        }
        get {Int64(userDefault.integer(forKey: idKey))}
    }
    
    
    
    private static let themeKey = "themeKey"
    static var themeColor: [String] {
        set { userDefault.set(newValue, forKey: themeKey)}
        get { return (userDefault.array(forKey: "themeKey") as? [String]) ?? ["E91E63"] }
    }
}
