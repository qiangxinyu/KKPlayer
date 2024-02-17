//
//  PlayerList.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/9.
//

import SwiftUI

extension PlayerManager {
    
    static func play(model: AudioModel, list: [AudioModel]) {
        main.playerList.play(model: model, list: list)
    }
    
    static func play(model: AudioModel) {
        main.playerList.play(model: model)
    }
    
    static func insertNext(model: AudioModel) {
        main.playerList.insertNext(model: model)
    }
    
    static func play() {
        main.player.play()
    }
    
    static func replay() {
        main.player.replay()
    }
    
    static func seek(to: TimeInterval) {
        main.player.seek(to: to)
    }
    
    static func pause() {
        main.player.pause()
    }
    
    static func next() {
        main.playerList.next()
    }
    
    static func previous() {
//        if PlayerInfo.main.currentPlayerTime > 5 {
//            replay()
//        } else {
//            main.playerList.previous()
//        }
    }
}


extension PlayerManager {
    class PlayerList: ObservableObject {
        
        @Published var items: [AudioModel] = []
        @Published var originItems: [AudioModel] = []
        @Published var index = 0
        
        @Published var loop: Loop = .plain {
            didSet {
                switch loop {
                case .plain: items = originItems
                case .single: items = []
                case .random: items = originItems.shuffled()
                }
            }
        }
        
        
        func play(model: AudioModel, list: [AudioModel]) {
            originItems = list
            loop = main.loop
            play(model: model)
        }
        
        func play(model: AudioModel) {
            
            guard let index = items.firstIndex(of: model) else {
                UIAlertController.show(title: "播放\(String(describing: model.name))出错，播放列表中没找到")
                return
            }
            
            self.index = index

            PlayerManager.main.player.play(model: model)
        }
        
        func insertNext(model: AudioModel) {
            items.insert(model, at: index + 1)
//            NoticeManager.main.text = "已加入下一首播放"
        }
        
        
        func play() {
            switch main.loop {
            case .single:
                PlayerManager.replay()
            case .plain, .random:
                PlayerManager.play(model: items[index])
            }
        }
       
        
        
        func next() {
            index += 1
            if index >= items.count {
                index = 0
            }
            play()
        }
       
        
        func previous() {
            index -= 1
            if index < 0 {
                index = items.count - 1
            }
            play()
        }
    }

}



extension PlayerManager.PlayerList {
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
        
        func next() -> Self {
            switch self {
            case .plain: return .random
            case .random: return .single
            case .single: return .plain
            }
        }
    }
}
