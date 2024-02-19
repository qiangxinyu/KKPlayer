//
//  SettingViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit


class SettingView: View, HomePopViewAnimate {
    static let shared = SettingView()
    
    private let contentView = ContentView()
    
    private let contentWidth = kScreenWidth - 80
    private var begainX: CGFloat = 0
    
    override func initSelf() {
        kMainWindow.addSubview(self)
      
        frame = .init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        alpha = 0
        
        
        initContentView()
    }
    
    static func show() {
        shared.moveAnimate(isShow: true) { _ in
            shared.contentView.x = 0
        }
    }
    
    static func hidden() {
        shared.moveAnimate(isShow: false) { _ in
            shared.contentView.x = -shared.contentWidth
        }
    }
}





// MARK: Content View

extension SettingView {
    private func initContentView() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .orange
        kMainWindow.addSubview(contentView)

        contentView.pan { p in
            if let pan = p as? UIPanGestureRecognizer {
                self.handlePan(pan: pan)
            }
        }
        contentView.frame = .init(x: -contentWidth, y: 0, width: contentWidth, height: kScreenHeight)

    }
    
    private func handlePan(pan: UIPanGestureRecognizer) {
        
        let point = pan.translation(in: kMainWindow)
        let moveX = point.x - begainX

        switch pan.state {
        case .began:
            begainX = point.x
        case .changed:
            
            if moveX < 0 {
                contentView.x = moveX
                handMovePopView(scale: abs(moveX) / contentView.width)
            }

        default:
            if abs(moveX) > contentView.width / 2 {
                SettingView.hidden()
            } else {
                SettingView.show()
            }
        }
    }
    
    private class ContentView: UIView, PanProtocol {}
}
