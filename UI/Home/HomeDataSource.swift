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
    private static var itemsChanges = [Change]()
    static func itemsChange(_ change: @escaping Change) {
        itemsChanges.append(change)
    }
    
    /// 数据库查询结果
    /// 排序筛选数据库耗时稳定，所以不去进行自己操作内存数组排序筛选
    private(set) static var items: [AudioModel] = [] {
        didSet {
            DispatchQueue.main.async {
                itemsChangesPost()
            }
        }
    }
    
    static func itemsChangesPost() {
        itemsChanges.forEach {$0()}
    }
    
    /// 筛选
    static var predicate: NSPredicate? = nil {
        didSet { refreshItems() }
    }
    
    static var keyword: String? = nil {
        didSet {
            if let keyword = keyword, !keyword.isEmpty {
                predicate = NSPredicate(format: "name contains[c] %@ or letters contains[c] %@ or artist contains[c] %@ or artistLetters contains[c] %@ or album contains[c] %@ or albumLetters contains[c] %@ ", keyword, keyword, keyword, keyword, keyword, keyword)

            } else {
                predicate = nil
            }
        }
    }
    
    
    static var sort: Sort = Sort.list[0] {
        didSet {
            refreshItems()
        }
    }

    
    static func refreshItems() {
        let request = AudioModel.fetchRequest()
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor.init(key: sort.key, ascending: sort.ascending)]

        do {
            items = try CoreDataContext.fetch(request)
        } catch {}
    }
}



extension HomeDataSource {
    
    struct Sort: Equatable {
        var key: String
        var ascending: Bool
        
        var name: String {
            
            switch key {
            case "nameSort": return "歌名"
            case "artistSort": return "歌手"
            case "createTime": return "添加时间"
            case "length": return "名称长度"
            case "count": return "播放次数"
            default: return ""
            }
            
        }
        
        static let list: [Sort] = [
            .init(key: "createTime", ascending: true),
            .init(key: "createTime", ascending: false),
            
            .init(key: "nameSort", ascending: true),
            .init(key: "nameSort", ascending: false),
            
            .init(key: "artistSort", ascending: true),
            .init(key: "artistSort", ascending: false),
        
            .init(key: "length", ascending: true),
            .init(key: "length", ascending: false),
        
            .init(key: "count", ascending: true),
            .init(key: "count", ascending: false)
        ]
    }
}
