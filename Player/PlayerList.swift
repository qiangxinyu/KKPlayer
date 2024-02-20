//
//  PlayerList.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/9.
//

import SwiftUI


class PlayerList {
    
    var items: [AudioModel] = []
    var originItems: [AudioModel] = []
    var index = 0
    
    var loop: Loop = .plain {
        didSet {
            switch loop {
            case .plain: items = originItems
            case .single: items = []
            case .random: items = originItems.shuffled()
            }
            
            refreshIndex(PlayerManager.currentModel)
            PlayerManager.playListChanges.forEach {$0()}
        }
    }
    
    func settingPlayList(list: [AudioModel]) {
        originItems = list
        loop = PlayerManager.loop
    }
    
    func play(model: AudioModel, list: [AudioModel]) {
        originItems = list
        loop = PlayerManager.loop
        
        refreshIndex(model)

        play(model: model)
    }
    
    func play(model: AudioModel) {
        PlayerManager.player.play(model: model)
    }
    
    func refreshIndex(_ model: AudioModel?) {
        if model == nil || items.isEmpty {
            return
        }
        guard let index = items.firstIndex(of: model!) else {
            return
        }
        
        self.index = index
    }
    
    func insertNext(models: [AudioModel]) {
        if items.count <= index {
            items.append(contentsOf: models)
        } else {
            items.insert(contentsOf: models, at: index + 1)
        }
        
        PlayerManager.playListChanges.forEach {$0()}

        TipView.show("已加入下一首播放")
    }
    
    
    /// 除了单曲循环外，  上一首 下一首必走方法
    func playWidthIndex() {
        if items.count == 0 {
            PlayerManager.clickPlayPauseButton()
            return
        }
        switch loop {
        case .single:
            PlayerManager.replay()
        case .plain, .random:
            play(model: items[index])
        }
    }
   
    
    
    func next() {
        index += 1
        if index >= items.count {
            index = 0
        }
        playWidthIndex()
    }
   
    
    func previous() {
        index -= 1
        if index < 0 {
            index = items.count - 1
        }
        playWidthIndex()
    }
}

extension PlayerList {
    enum Loop: Int16 {
        case single = 2
        case plain = 0
        case random = 1
        
        var image: String {
            get {
                switch self {
                case .plain: return "icon_loop_plain"
                case .random: return "icon_loop_random"
                case .single: return "icon_loop_single"
                }
            }
        }
        
        mutating func next() {
            switch self {
            case .plain: return self = .random
            case .random: return self = .single
            case .single: return self = .plain
            }
        }
    }
}
