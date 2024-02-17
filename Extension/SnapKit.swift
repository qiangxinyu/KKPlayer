//
//  SnapKit.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/16.
//

import Foundation

import SnapKit

extension ConstraintMaker {
    
    /// 宽高比
    /// - Parameters:
    ///   - ratio: 宽高比
    ///   - instance: view
    public func aspectRatio(_ ratio: CGFloat, view: ConstraintView) {
        width.equalTo(view.snp.height).multipliedBy(ratio)
    }
}
