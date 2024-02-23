//
//  SettingTimerViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/23.
//

import UIKit


class SettingTimerViewController: PresentViewController {
    static let shared = SettingTimerViewController()
    
    var isAutoStop = false
    
    private var autoStopTimer: Timer? = nil
    private var autoStopTime: Int = 0
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    
    private let saveButton = SaveButton(title: "启动")
    
    private let remainingTimeLabel = UILabel()
    
    private var presetsButtons = [SaveButton]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSettingTimer()
        initRemainingTime()
       
        changeViews()
    }
    
    private func initSettingTimer() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(saveButton)
        
        titleLabel.text = "设置时间 min"
        textField.keyboardType = .numberPad
        
        titleLabel.frame = .init(x: Theme.marginOffset, y: 40, width: 0, height: 0)
        titleLabel.sizeToFit()
        
        
        textField.font = .pingFang(size: 16)
        textField.backgroundColor = .B04
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.leftViewMode = .always
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 8, height: 0))
        textField.rightViewMode = .always
        textField.rightView = .init(frame: .init(x: 0, y: 0, width: 8, height: 0))
        textField.frame = .init(x: Theme.marginOffset, y: titleLabel.frame.maxY + 12, width: view.width - 2 * Theme.marginOffset, height: 44)
       
        saveButton.frame = textField.frame
        saveButton.y = textField.frame.maxY + 12
        saveButton.touchUpInside {
            if self.saveButton.title == "启动" {
                self.textField.endEditing(true)
                let time = Int(self.textField.text ?? "") ?? -1
                
                if time <= 0 {
                    TipView.show("需要正整数")
                    return
                }
                
                self.autoStopTime = time * 60
                self.startTimer()
            } else if self.saveButton.title == "停止" {
                self.stopTimer()
            } else if self.saveButton.title == "重置" {
                self.isAutoStop = false
                self.changeViews()
            }
            
        }
        
        let itemSpace: CGFloat = 10
        let itemWidth = (view.width - itemSpace * 2 - Theme.marginOffset * 2) / 3
        
        let x = Theme.marginOffset
        let y = saveButton.frame.maxY + 12
        
        for (row, rowList) in [[10, 14, 18], [22, 26, 30]].enumerated() {
            for (col, time) in rowList.enumerated() {
                let newX = x + (itemWidth + itemSpace) * CGFloat(col)
                let newY = y + CGFloat(row) * (44 + 12)
                
                let button = SaveButton(title: "\(time)")
                button.frame = .init(
                    x: newX,
                    y: newY,
                    width: itemWidth,
                    height: 44)
                view.addSubview(button)
                
                button.touchUpInside {
                    self.autoStopTime = time * 60
                    self.startTimer()
                }
            }
        }
    }
    
    private func initRemainingTime() {
        view.addSubview(remainingTimeLabel)
        
        remainingTimeLabel.textAlignment = .center
        remainingTimeLabel.frame = textField.frame
    }
    
    private func startTimer() {
        autoStopTimer?.invalidate()
        autoStopTimer = nil
        isAutoStop = false
        
        
        /// 控制器不释放 所以不考虑循环引用
        autoStopTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.autoStopTime -= 1
            if self.autoStopTime == 0 {
                self.autoStopTimer?.invalidate()
                self.autoStopTimer = nil
                self.isAutoStop = true
                
                self.saveButton.title = "重置"
            }
            
            self.remainingTimeLabel.text = "剩余时间: \(self.autoStopTime) s"

        })
        
        remainingTimeLabel.text = "剩余时间: \(autoStopTime) s"
        changeViews()

    }
    
    private func stopTimer() {
        autoStopTimer?.invalidate()
        autoStopTimer = nil
        isAutoStop = false
        
        changeViews()
    }
    
    private func changeViews() {
        let isStartTimer = autoStopTimer != nil
        for view in view.subviews {
            view.isHidden = isStartTimer
        }

        saveButton.isHidden = false
        saveButton.title = isStartTimer ? "停止" : "启动"
        remainingTimeLabel.isHidden = !isStartTimer
    }
}
