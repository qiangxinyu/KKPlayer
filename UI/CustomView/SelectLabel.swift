//
//  Label.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit

class SelectLabel: UILabel {
    var selectBackgroundColor: UIColor?
    var defaultBackgroundColor: UIColor?
    
    override var backgroundColor: UIColor? {
        didSet {
            if selectBackgroundColor != backgroundColor {
                defaultBackgroundColor = backgroundColor
            }
        }
    }
    
    var isSelected = false {
        didSet {
            if selectTextColor != nil {
                textColor = isSelected ? selectTextColor : defaultTextColor
            }
            if selectFont != nil {
                font = isSelected ? selectFont : defaultFont
            }
            if selectBackgroundColor != nil {
                backgroundColor = isSelected ? selectBackgroundColor : defaultBackgroundColor
            }
        }
    }
    
    var defaultTextColor: UIColor?
    var selectTextColor: UIColor?
    override var textColor: UIColor! {
        didSet {
            if selectTextColor != textColor {
                defaultTextColor = textColor
            }
        }
    }
    
    var defaultFont: UIFont?
    var selectFont: UIFont?
    override var font: UIFont! {
        didSet {
            if selectFont != font {
                defaultFont = font
            }
        }
    }

    
    var margins: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: margins))
    }
}

