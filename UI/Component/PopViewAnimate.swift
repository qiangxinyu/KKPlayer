//
//  PopViewAnimate.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/17.
//

import UIKit

fileprivate let maskView = {
    let maskView = UIView()
    maskView.backgroundColor = .black.withAlphaComponent(0.1)
    maskView.alpha = 0
    return maskView
}()

/// 固定的 view  永远不会变  直接放这里方便用
fileprivate let parentView = HomeViewController.shared.view!


protocol HomePopViewAnimate: View {
    func moveAnimate(isShow: Bool, contentViewAnimate: @escaping (Bool) -> Void)
    
    
    static func hidden()
    static func show()
    
    /// 手动移动
    /// - Parameter scale: 0 - 1
    func handMovePopView(scale: CGFloat)
}


fileprivate let minScale: CGFloat = 0.88
extension HomePopViewAnimate {
    func handMovePopView(scale: CGFloat) {
        maskView.alpha = 1 - scale
        
        let newScale = minScale + ((1 - minScale) * scale)
        parentView.layer.transform = CATransform3DMakeScale(newScale, newScale, 1)
    }
    
    
    func moveAnimate(isShow: Bool, contentViewAnimate: @escaping (Bool) -> Void) {
        
        if isShow, maskView.superview == nil {
            parentView.clipsToBounds = true
            parentView.layer.cornerRadius = 12
            
            parentView.addSubview(maskView)
            maskView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut) {
            
            self.alpha = isShow ? 1 : 0
            maskView.alpha = isShow ? 1 : 0
            
            contentViewAnimate(isShow)
            
            let scale = isShow ? minScale : 1
            parentView.layer.transform = CATransform3DMakeScale(scale, scale, 1)
        }
        completion: { _ in
            if !isShow {
                parentView.clipsToBounds = false
                parentView.layer.cornerRadius = 0
                maskView.removeFromSuperview()
            }            
        }
    }
}
