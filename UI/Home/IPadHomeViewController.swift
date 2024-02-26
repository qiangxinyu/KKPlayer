//
//  IPadHomeViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/25.
//

import UIKit

class IPadHomeViewController: UIViewController {
    private let homeView = HomeViewController.shared.view!
    private let controlView = PlayerControl.shared.view!

    override func viewDidLoad() {
        kMainWindow.backgroundColor = .HEX("DDDDDD")

        
        view.addSubview(homeView)
        addChild(HomeViewController.shared)
        
        view.addSubview(controlView)
        addChild(PlayerControl.shared)
        
        
        homeView.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(443)
        }
        
        controlView.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview()
            make.left.equalTo(homeView.snp.right).offset(1)
        }
        
    }
}
