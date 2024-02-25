//
//  AloutMe.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/25.
//

import UIKit

class AloutMeViewController: PresentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = IV()
        let name = Label()
        let version = Label()
        let bottomLabel = Label()
        
        imageView.vc = self
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "AppIcon")
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(160)
            make.top.equalTo(80)
        }
        
        
        if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            name.text = appName
        }

        
        view.addSubview(name)
        name.font = .pingFang(name: .medium, size: 24)
        name.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(24)
        }
        
        view.addSubview(version)
        version.font = .pingFang(size: 16)
        version.textColor = .T02
        version.text = "V " + kAPPVersion
        version.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(name.snp.bottom).offset(12)
        }
        
        view.addSubview(bottomLabel)
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .center
        bottomLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kMainWindow.safeAreaInsets.bottom - 20)
            make.centerX.equalToSuperview()
        }
        bottomLabel.font = .pingFang(size: 12)

        bottomLabel.text = "Copyright@2022\r\nCaptain Qxy92 & Cool KongKong"
    }
    
    
    class IV: UIImageView {
        weak var vc: UIViewController? = nil
        var count = 0
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            count += 1
            if count == 5 {
                count = 0
                vc?.present(ChangeIconViewController(), animated: true)
            }
        }
    }
    
}
