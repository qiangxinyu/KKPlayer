//
//  PlayerStatus+CoreDataProperties.swift
//  
//
//  Created by 强新宇 on 2024/2/9.
//
//

import Foundation
import CoreData


extension PlayerStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerStatus> {
        return NSFetchRequest<PlayerStatus>(entityName: "PlayerStatus")
    }

    @NSManaged public var audioID: Int64
    @NSManaged public var sort: String?
    @NSManaged public var ascending: Bool
    @NSManaged public var playTime: Double
    @NSManaged public var loop: Int16

}


extension PlayerStatus {
    static func save() {
//        if let model = PlayerManager.currentModel {
//            main.audioID = model.id
//        }
//        
//        switch PlayerManager.main.sort {
//        case .sort(let sort, let ascending):
//            main.ascending = ascending
//            main.sort = sort.rawValue
//        default: break
//        }
//        main.loop = PlayerManager.main.loop.rawValue
//        main.playTime = PlayerInfo.main.currentPlayerTime
        
        
        try? CoreDataContext.save()
    }
}
