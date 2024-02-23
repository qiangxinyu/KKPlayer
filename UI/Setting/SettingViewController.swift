//
//  SettingViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit


class SettingViewController: ViewController {
    static let shared = SettingViewController()

    private let themeSetting = TouchItemView()
    private let timerSetting = TouchItemView()
    private let abloutMe = TouchItemView()
    private let iCloud = SwitchItemView()
    private let webTransfer = SwitchItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initSubviews()

    }

}




// MARK: layout subviews
extension SettingViewController {
    private func initSubviews() {
        view.addSubview(themeSetting)
        view.addSubview(timerSetting)
        view.addSubview(abloutMe)
        view.addSubview(iCloud)
        view.addSubview(webTransfer)

        themeSetting.title = "切换主题"
        themeSetting.touchUpInside {[weak self] in
            self?.present(SettingThemeColorViewController(), animated: true)
        }
        
        timerSetting.title = "定时停止"
        timerSetting.touchUpInside {
            
        }
        
        abloutMe.title = "关于我们"
        abloutMe.touchUpInside {
            
        }
        
        iCloud.title = "iCloud备份"
        webTransfer.title = "网页传输"
        
        var y: CGFloat = kMainWindow.safeAreaInsets.top
        let itemHeight: CGFloat = 44
        
        [
            themeSetting,
            timerSetting,
            abloutMe,
            iCloud,
            webTransfer
        ].forEach { view in
            view.frame = .init(x: 0, y: y, width: kScreenWidth, height: itemHeight)
            y += itemHeight
        }
    }
}



// MARK: Item View

fileprivate class ItemView: View {
    private let label = UILabel()
    private let lineView = UIView()
    
    
    var title: String? {
        set { label.text = newValue }
        get { label.text }
    }
    
    override func initSelf() {
        addSubview(label)
        addSubview(lineView)
        
        label.font = Theme.titleFont
        label.textColor = .T01
        
        label.snp.makeConstraints { make in
            make.left.equalTo(Theme.marginOffset)
            make.top.bottom.equalToSuperview()
        }
        
        lineView.backgroundColor = .B03
        lineView.snp.makeConstraints { make in
            make.left.equalTo(Theme.marginOffset)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

fileprivate class ArrowItemView: ItemView {
    private let arrow = UIImageView(image: .init(named: "edit／rightarrow／normat"))
    override func initSelf() {
        super.initSelf()
        
        addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-Theme.marginOffset)
        }
    }
}

fileprivate class SwitchItemView: ItemView {
    private let switchView = UISwitch()
        
    override func initSelf() {
        super.initSelf()
        
        addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-Theme.marginOffset)
        }
    }
}

fileprivate class TouchItemView: ArrowItemView, TapProtocol {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
    
   
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = Theme.touchAlpha
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1

    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1

    }
}
