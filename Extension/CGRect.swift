//
//  CGRect.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit

extension CGRect {
    @discardableResult
    mutating func also(handle: (inout Self) -> Void) -> Self {
        handle(&self)
        return self
    }
}
