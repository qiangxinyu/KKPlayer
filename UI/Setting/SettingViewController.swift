//
//  SettingViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit
import GCDWebServer


class SettingViewController: PresentViewController {
    static let shared = SettingViewController()

    private let themeSetting = ArrowItemView()
    private let timerSetting = ArrowItemView()
    private let abloutMe = ArrowItemView()
    private let iCloud = SwitchItemView()
    private let webTransfer = SwitchItemView()
    
    private let webUploader = GCDWebUploader.init(uploadDirectory: KKFileManager.Path.audio().rawValue)
    var url: String? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webUploader.allowedFileExtensions = ["mp3"]
        webUploader.delegate = self

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
        timerSetting.touchUpInside {[weak self] in
            self?.present(SettingTimerViewController.shared, animated: true)
        }
        
        abloutMe.title = "关于我们"
        abloutMe.touchUpInside {[weak self] in
            self?.present(AloutMeViewController(), animated: true)
        }
        
        iCloud.title = "iCloud备份"
        iCloud.touchUpInside {
            UIAlertController.show(title: "目前不可用")
        }
        webTransfer.title = "网页传输"
        
        webTransfer.valueChange = {[weak self] isOn in
            if isOn {
                // get newwork authority
                URLSession.shared.dataTask(with: URL(string: "https://github.com")!).resume()

                
                self?.webUploader.start()
                let url = self?.webUploader.serverURL?.relativeString ?? ""
                self?.webTransfer.title = "网页传输：\(url)"
                self?.paste()
            } else {
                self?.webTransfer.title = "网页传输"
                self?.webUploader.stop()
            }
        }
        
        webTransfer.touchUpInside {[weak self] in
            if self?.webUploader.isRunning == true {
                self?.paste()
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var y: CGFloat = kMainWindow.safeAreaInsets.top
        let itemHeight: CGFloat = 44

        [
            themeSetting,
            timerSetting,
            abloutMe,
            iCloud,
            webTransfer
        ].forEach { v in
            v.frame = .init(x: 0, y: y, width: view.width, height: itemHeight)
            y += itemHeight
        }
    }
}


extension SettingViewController: GCDWebUploaderDelegate {
    private func paste() {
        UIPasteboard.general.string = webUploader.serverURL?.relativeString ?? ""
        UIAlertController.show(title: "提示", message: "已经复制链接到粘贴板，用电脑浏览器打开(最好用 Chrome)，手机和电脑必须在同一个局域网下!!!\n\n!!!注意保持App一直处于打开状态，不能切后台或者关闭屏幕!!!\n\n !!!不要在网页里面创建文件夹，也不要改文件名字!!!\n\n!!!不用就关掉，不然开着费电!!!", sureText: "确定")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        let url = URL(fileURLWithPath: path)
        
        let request = AudioModel.fetchRequest()
        request.predicate = .init(format: "relativePath == %@", url.lastPathComponent)

        let list = try? CoreDataContext.fetch(request)
        
        if list?.count == 1 {
            CoreDataContext.delete(list![0])
            try? CoreDataContext.save()
            PlayerManager.deleteItemRefresh(isPlaying: list![0] == PlayerManager.currentModel)
        }
    }
    
  
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        let url = URL(fileURLWithPath: path)
        guard url.lastPathComponent.hasSuffix(".mp3") else {
            TipView.show("只支持 mp3 文件")
            return
        }
        
        let newPath = KKFileManager.Path.tmp(component: url.lastPathComponent)
        KKFileManager.moveFile(path: .audio(component: url.lastPathComponent), toPath: newPath)
        
        AudioFileQueue.push(audio: newPath.url)
    }
}

// MARK: Item View

fileprivate class ItemView: View, TapProtocol {
    private let label = UILabel()
    private let lineView = UIView()
    
    
    var title: String? {
        set { label.text = newValue }
        get { label.text }
    }
    
    override func initSelf() {
        addSubview(label)
        addSubview(lineView)
        
        lineView.backgroundColor = .B03
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Theme.marginOffset)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        label.font = Theme.titleFont
        label.textColor = .T01
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Theme.marginOffset)
            make.top.bottom.equalToSuperview()
        }        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
    
   
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .HEX("AAAAAA")
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .white
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .white
    }
}

fileprivate class ArrowItemView: ItemView {
    private let arrow = UIImageView(image: .init(named: "edit／rightarrow／normat"))
    override func initSelf() {
        super.initSelf()
        
        addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Theme.marginOffset)
        }
    }
}

fileprivate class SwitchItemView: ItemView {
    private let switchView = UISwitch()
        
    override func initSelf() {
        super.initSelf()
        
        switchView.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-Theme.marginOffset)
        }
    }
    
    var valueChange: ((Bool) -> Void)? = nil
    @objc func switchChange() {
        valueChange?(switchView.isOn)
    }
}
