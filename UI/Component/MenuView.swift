//
//  MenuView.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/19.
//

import UIKit

class MenuView: View, TapProtocol {
    let contentView = UIView()
    
    override func addSubview(_ view: UIView) {
        fatalError("应该给 contentView 添加")
    }
    
    override func initSelf() {
        backgroundColor = .black.withAlphaComponent(0.15)
        alpha = 0
        frame = kScreenBounds

        
        touchUpInside {[weak self] in
            self?.hidden()
        }

        super.addSubview(contentView)
        contentView.backgroundColor = .B03
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self {
            return false
        }
        return true
    }
    
    
    /// 弹出菜单
    /// - Parameter atPoint: 相对于 window 的位置
    /// 因为 app 内弹菜单的按钮都在屏幕右边，所以默认弹框在坐标左边
    func show(atPoint: CGPoint) {
        kMainWindow.addSubview(self)
        contentView.x = atPoint.x - contentView.width
        /// 弹在左上
        if contentView.height + atPoint.y > kScreenHeight - 100 {
            contentView.y = atPoint.y - contentView.height
        } else { //左下
            contentView.y = atPoint.y
        }
        
        animate(isShow: true)
    }
    
    func show(ges: UIGestureRecognizer) {
        show(atPoint: ges.location(in: nil))
    }
    
    func hidden() {
        animate(isShow: false)
    }
    
    private func animate(isShow: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.alpha = isShow ? 1 : 0
        } completion: { _ in
            if !isShow {
                self.removeFromSuperview()
            }
        }
    }
    
    

}
