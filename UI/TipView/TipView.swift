//
//  TipView.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/20.
//

import UIKit


class TipView {
    private init() {}
    
    private static var timer: Timer?
    private static let margin = 20
    
    @discardableResult
    static func show(_ title: String, autoClose: Bool = true) -> UIView {
        /// 半透明背景
        let view = UIView(frame: kScreenBounds)
        view.backgroundColor = .black.withAlphaComponent(0.1)
        
        
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .B03
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 10

        let label = UILabel()
        
        label.font = Theme.titleFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .T01
        label.text = title

        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.left.top.equalTo(margin)
            make.right.bottom.equalTo(-margin)
        }
        
        DispatchQueue.main.async {
            kMainWindow.addSubview(view)
            
            if autoClose {
                timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { t in
                    view.removeFromSuperview()
                    t.invalidate()
                })
                RunLoop.main.add(timer!, forMode: .common)
            }
        }
        
        return view
    }
}
