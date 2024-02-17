//
//  CGPoint.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/8.
//

import Foundation

extension CGPoint {
    static func -(point1: Self, point2: Self) -> CGFloat {
        let xDistance = point2.x - point1.x
        let yDistance = point2.y - point1.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
}
