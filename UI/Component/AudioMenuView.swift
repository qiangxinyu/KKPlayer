//
//  AudioMenuView.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/20.
//

import UIKit

class AudioMenuView: MenuView {
    static let shared = AudioMenuView()
    
    static func show(ges: UIGestureRecognizer, list: [AudioModel]) {
        shared.show(ges: ges)
        shared.selectList = list
    }
    
    private var selectList = [AudioModel]()
    
    private let deleteButton = MainThemeButton(style: .imageRight, title: "删除", imageName: "icon_delete")
    private let nextPlayButton = MainThemeButton(style: .imageRight, title: "下一首播放", imageName: "icon_add_play_list")
    private let editButton = MainThemeButton(style: .imageRight, title: "编辑", imageName: "icon_edit")
    private let shareButton = MainThemeButton(style: .imageRight, title: "分享", imageName: "icon_share")

    override func initSelf() {
        super.initSelf()
        
        let itemWidth: CGFloat = 240
        let itemHeight: CGFloat = 44
        
        contentView.width = itemWidth
        
        
        var y: CGFloat = 0
        
        formatButton(button: deleteButton)
        formatButton(button: nextPlayButton)
        formatButton(button: editButton)
        formatButton(button: shareButton)
      
        
        
        deleteButton.touchUpInside {
            self.hidden()
            self.deleteAudios()
        }
        
        nextPlayButton.touchUpInside {
            self.hidden()
            PlayerManager.insertNext(models: self.selectList)
        }
        
        editButton.touchUpInside {
            self.hidden()
            let editVC = EditAudioInfoViewController()
            editVC.list = self.selectList
            HomeViewController.shared.present(editVC, animated: true)
        }
        
        shareButton.touchUpInside {
            self.hidden()
            Share.share(models: self.selectList)
        }
      

        [deleteButton, nextPlayButton, editButton, shareButton].forEach { item in
            item.frame = .init(x: 0, y: y, width: itemWidth, height: itemHeight)
            contentView.addSubview(item)
            if item == deleteButton {
                item.label?.textColor = .red
            }
            y += (itemHeight + 1)
        }
        
        contentView.height = y - 1
    }
    
    private func deleteAudios() {
        
        var title = "确定要删除这\(selectList.count)首歌吗？？？"

        if self.selectList.count == 1 {
            title = "确定要删除《\(selectList[0].name!)》吗？"
        }
        
        UIAlertController.showDeleteAlert(title: title, sureText: "删除", sureBlock: {_ in
            
            DispatchQueue.global().async {
                var tipView: UIView?
                if self.selectList.count > 30 {
                    tipView = TipView.show("删除中...", autoClose: false)
                }
                
                var isPlaying = false
                self.selectList.forEach { model in
                    if model == PlayerManager.currentModel {
                        isPlaying = true
                    }
                    model.clearDisk()
                    CoreDataContext.delete(model)
                }
                
                try? CoreDataContext.save()
                
                DispatchQueue.main.async {
                    tipView?.removeFromSuperview()
                    
                    if HomeViewController.shared.status == .select {
                        HomeViewController.shared.notSelectAllItems()
                    }
                }
                
                PlayerManager.deleteItemRefresh(isPlaying: isPlaying)
            }
            
        }, cancelText: "取消")
    }
    
    private func formatButton(button: MainThemeButton) {
        button.backgroundColor = .white
        button.label?.textAlignment = .left
        button.label?.textColor = .T02
        button.label?.font = .pingFang(size: 16)
        button.imageEdgeInserts = .init(edges: 10)
        button.titleEdgeInserts = .init(top: 0, left: Theme.marginOffset, bottom: 0, right: 0)
    }
}
