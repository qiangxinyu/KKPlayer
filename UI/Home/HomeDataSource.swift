//
//  HomeDataSource.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/17.
//


import UIKit

class HomeDataSource {
    private init() {}
    
    
    /// 列表变动通知  目前只有主页列表需要
    private static var itemChanges = [Change]()
    static func itemChange(_ change: @escaping Change) {
        itemChanges.append(change)
    }
    
    /// 数据库查询结果
    /// 排序筛选数据库耗时稳定，所以不去进行自己操作内存数组排序筛选
    private(set) static var items: [AudioModel] = [] {
        didSet {
            itemChanges.forEach {$0()}
        }
    }
    
    /// 筛选
    static var predicate: NSPredicate? = nil {
        didSet {
            if predicate != nil { refreshItems() }
        }
    }
    
    static var keyword: String = "" {
        didSet {
            refreshItems()
        }
    }
    
        
    
    static var sort: SortStyle = .sort(sort: .time, ascending: false) {
        didSet {
            if sort != .select {
                refreshItems()
            }
        }
    }

    
    static func refreshItems() {
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
}



extension HomeDataSource {
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
        case sort(sort: Sort, ascending: Bool)
        
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
