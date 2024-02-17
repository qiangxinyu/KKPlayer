//
//  PlayerControl.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit


class PlayerControl: View {
    static let shared = PlayerControl()
    
    private let contentView = View()
    
    private let contentHeight = kScreenHeight - 100
    
    override func initSelf() {
        kMainWindow.addSubview(self)
        kMainWindow.addSubview(contentView)
//        touchUpInside = { _ in
//            self.hidden()
//        }
        
        backgroundColor = .black.withAlphaComponent(0.12)
        frame = .init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        alpha = 0
        
        contentView.backgroundColor = .blue
        contentView.layer.cornerRadius = 12
        contentView.frame = .init(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentHeight)
    }
    
    
    func show() {
        moveAnimate()
    }
    
    func hidden() {
        moveAnimate(isShow: false)
    }
    
    
    private func moveAnimate(isShow: Bool = true) {
        let parentView = HomeViewController.shared.view!
        
        
        if isShow {
            parentView.clipsToBounds = true
            parentView.layer.cornerRadius = 12
        }
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut) {
            self.alpha = isShow ? 1 : 0
            self.contentView.y = isShow ? (kScreenHeight - self.contentHeight) : kScreenHeight
            
            let scale = isShow ? 0.9 : 1
            parentView.transform = CGAffineTransformMakeScale(scale, scale)
        }
        completion: { _ in
            if !isShow {
                parentView.clipsToBounds = false
                parentView.layer.cornerRadius = 0
            }
        }
    }
    
}
