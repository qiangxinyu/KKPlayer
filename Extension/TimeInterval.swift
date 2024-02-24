//
//  TimeInterval.swift
//  KKPlayer_New
//
//  Created by 强新宇 on 2024/2/9.
//

import UIKit


extension TimeInterval {
    
    var minutesSecond: String {
        let time = Int(self)
        let min = time / 60
        let second = time % 60
        
   
        let minStr = (min < 10 ? "0" : "") + "\(min)"
        let secondStr = (second < 10 ? "0" : "") + "\(second)"

    
        return "\(minStr):\(secondStr)"
    }
}
