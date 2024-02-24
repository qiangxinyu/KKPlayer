//
//  Porperty.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit



public func print(_ args: Any...) {
    #if DEBUG
    print("------------------------------ \\_/ ------------------------------", separator: "", terminator: "\n")
    print(args, separator: "--->>>", terminator: "\n")
    print("------------------------------ /_\\ ------------------------------", separator: "", terminator: "\n")
    #endif
}

/// 设备类型
public let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
public let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad



/// APP 版本号
public let kAPPVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"


func refreshScreenInfo() {
    kScreenBounds = UIScreen.main.bounds
    kScreenSize = kScreenBounds.size
    kScreenWidth = kScreenSize.width
    kScreenHeight = kScreenSize.height
    
    statusBarHeight = kMainWindow.safeAreaInsets.top

    kNavigationHeight = statusBarHeight + kNavigationBarHeight
}

fileprivate(set) var kScreenBounds = UIScreen.main.bounds
fileprivate(set) var kScreenSize: CGSize = kScreenBounds.size
fileprivate(set) var kScreenWidth: CGFloat = kScreenSize.width
fileprivate(set) var kScreenHeight: CGFloat = kScreenSize.height



/// 导航栏高度
fileprivate(set) var kNavigationHeight: CGFloat = 0
let kNavigationBarHeight: CGFloat = 44

/// 是否是刘海
let isBangs = { statusBarHeight > 30 }

var kTabBarHeight: CGFloat = 44

/// 状态栏高度
fileprivate(set) var statusBarHeight: CGFloat = 0

/// 底部安全距离
let bottomSafeAreaHeight: CGFloat = statusBarHeight == 20 ? 0 : 34



/// 主 window
let kMainWindow = UIWindow(frame: kScreenBounds)
