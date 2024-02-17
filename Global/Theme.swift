//
//  Theme.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit


struct Theme {
    
    /// 默认字体大小  PingFang R 15
    static let textFont: UIFont = .pingFang(size: 15)

    /// 默认边距 12
    static let marginOffset: CGFloat = 12
    /// 默认图片宽高比  16 : 9
    static let imageRatio: CGFloat = 16 / 9

    /// 默认详情文本大小  PingFang R 12
    static let messageFont: UIFont = .pingFang(size: 12)

    
    //MARK: 标题

    /// 一级标题字体 PingFang Medium 17
    static let titleFont: UIFont = .pingFang(name: .medium, size: 17)
   
    //MARK: 二级标题

    /// 二而级标题字体 PingFang Medium 14
    static let titleFont1: UIFont = .pingFang(name: .medium, size: 14)
    


    
    //MARK: 导航栏
 
    /// 导航栏字体 PingFang R 17
    static let naviBarButtonTextFont: UIFont = .pingFang(size: 17)

    /// 导航栏文字字体 PingFang Medium 16
    static let naviBarSendButtonTextFont: UIFont = .pingFang(name: .medium, size: 16)
    
    //MARK: 按钮
 
    /// 按钮文字字体 PingFang R 14
    static let buttonTextFont: UIFont = .pingFang(size: 14)
    
    /// 按下后透明度 0.5
    static let touchAlpha: CGFloat = 0.5

   
    /// 弹框字体  PingFang R 17
    static let alertTextFont: UIFont = .pingFang(size: 17)
  

    /// 错误文本字体 PingFang R 12
    static let errorFont: UIFont = .pingFang(size: 12)
    
}
