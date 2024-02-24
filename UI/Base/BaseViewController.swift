//
//  BaseNaviBarViewController.swift
//  RayDataPro
//
//  Created by qiangxinyu on 2020/9/22.
//

import UIKit

class ViewController: UIViewController {}


class PresentViewController: ViewController {
    let lineView = UIView.presentLine

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Theme.marginOffset)
            make.width.equalTo(lineView.width)
            make.height.equalTo(lineView.height)
        }
    }
}

