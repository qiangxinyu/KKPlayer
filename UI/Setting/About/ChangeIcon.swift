//
//  ChangeIcon.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/25.
//

import UIKit


class ChangeIconViewController: PresentViewController {
    
    private var timeViews: [[UIView]] = []
    private var selectIconItem: ItemButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageNameList = [[nil, "AppIcon 1"]]
        
        let selectImage = UIApplication.shared.alternateIconName
        
        
        for rowList in imageNameList {
            
            var rowView = [UIView]()
            
            for name in rowList {
                
                let iv = ItemButton(imageName: name ?? "AppIcon")
                
                view.addSubview(iv)
                rowView.append(iv)
                
                if (selectImage == nil && selectIconItem == nil) || selectImage == name {
                    selectIconItem = iv
                    iv.isSelected = true
                }
                
                
                iv.touchUpInside {[weak self] in
                    if self?.selectIconItem == iv {
                        return
                    }
                    self?.selectIconItem?.isSelected = false
                    iv.isSelected = true
                    self?.selectIconItem = iv
                    
                  
                    UIApplication.shared.setAlternateIconName(name) { e in
//                        print("e", e)
                    }
                }
            }
            timeViews.append(rowView)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let itemSpace: CGFloat = 15
        let itemWidth = (view.width - itemSpace * 2 - Theme.marginOffset * 2) / 3
        
        let x = Theme.marginOffset
        let y: CGFloat = 50
        
        for (row, rowList) in timeViews.enumerated() {
                        
            for (col, v) in rowList.enumerated() {
                
                let newX = x + (itemWidth + itemSpace) * CGFloat(col)
                let newY = y + CGFloat(row) * (itemWidth + 12)
                
                v.frame = .init(
                    x: newX,
                    y: newY,
                    width: itemWidth,
                    height: itemWidth)
            }
        }
    }
    
    
    
    
    class ItemButton: Button {
        var isSelected = false {
            didSet {
                imageView?.layer.borderWidth = isSelected ? 2 : 0
            }
        }
        
        override func initSelf() {
            super.initSelf()
            imageView?.layer.cornerRadius = 8
            imageView?.layer.masksToBounds = true
            imageView?.layer.borderColor = UIColor.HEX("#28caad").cgColor
        }
        
        
    }
}
