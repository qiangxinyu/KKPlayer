//
//  PlayerManager.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/7.
//

import SwiftUI

class PlayerManager {
    private init() { getItems() }
    
    static func restorePlayerStatus() {
        main.restorePlayerStatus()
    }
    func restorePlayerStatus() {
        
        if let string = PlayerStatus.main.sort, let sort = Sort(rawValue: string) {
            self.sort = .sort(sort: sort, ascending: PlayerStatus.main.ascending)
        }
        
        let item = items.filter { $0.id == PlayerStatus.main.audioID }
        
        
        if item.count == 1 {
            PlayerManager.play(model: item[0], list: items)
            PlayerManager.pause()
            PlayerManager.seek(to: PlayerStatus.main.playTime)
        } else if item.count > 0 {
            UIAlertController.show(title: "数据库id有重复")
        }
        
        if let loop =  PlayerManager.PlayerList.Loop.init(rawValue: PlayerStatus.main.loop) {
            self.loop = loop
        }
    }
    
    static let main = PlayerManager()
    
    
    var playerList = PlayerList()
    var player = Player()
    
    

    
    func getItems() {
        
        let request = AudioModel.fetchRequest()
        request.predicate = predicate
        
        switch sort {
        case .select: break
        case .sort(let sort, let ascending):
            request.sortDescriptors = [NSSortDescriptor.init(key: sort.rawValue, ascending: ascending)]
        }

        do {
            items = try CoreDataContext.fetch(request)
        } catch {}
        
    }
    
    var predicate: NSPredicate? = nil {
        didSet {
            if predicate != nil {
                getItems()
            }
        }
    }
    
    
    @Published var items: [AudioModel] = []
    
    @Published var currentModel: AudioModel?
    
    static var currentModel: AudioModel? {
        set {
            main.currentModel = newValue
        }
        get {
            main.currentModel
        }
    }
    
    
    var sort: SortStyle = .sort(sort: .time, ascending: false) {
        didSet {
            items.sorted {
                
                switch sort {
                case .select: return false
                case .sort(let sort, let ascending):
                    return $0.id > $1.id
                }
            }
        }
    }
   
    
    @Published var loop: PlayerList.Loop = .plain {
        didSet {
            playerList.loop = loop
        }
    }
}




extension PlayerManager {
    enum Sort: String {
        case name = "nameSort"
        case time = "createTime"
        case artist = "artistSort"
        case length = "length"
        case count = "playCount"
        
        var name: String {
            get {
                switch self {
                case .name: return "歌名"
                case .time: return "添加时间"
                case .artist: return "艺人"
                case .length: return "名称长度"
                case .count: return "收听次数"
                }
            }
        }
    }
    
    enum SortStyle: Equatable {
        case select
        case sort(sort: PlayerManager.Sort, ascending: Bool)
        
        var text: String {
            switch self {
            case .select: return "选择"
            case let .sort(sort, ascending):
                return sort.name + " " + (ascending ? "↑" : "↓")
            }
        }
        
        
        static let list: [SortStyle] = [
            
            .select,
            .sort(sort: .name, ascending: true),
            .sort(sort: .name, ascending: false),
            .sort(sort: .time, ascending: true),
            .sort(sort: .time, ascending: false),
            .sort(sort: .artist, ascending: true),
            .sort(sort: .artist, ascending: false),
            .sort(sort: .length, ascending: true),
            .sort(sort: .length, ascending: false),
            .sort(sort: .count, ascending: true),
            .sort(sort: .count, ascending: false),
        ]
        
    }
}
