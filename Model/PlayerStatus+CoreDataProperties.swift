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

    @NSManaged public var audioObjectID: URL?
    @NSManaged public var sort: String?
    @NSManaged public var ascending: Bool
    @NSManaged public var playTime: Double
    @NSManaged public var loop: Int16

}


extension PlayerStatus {
    
    
    static func save() {
        if let model = PlayerManager.currentModel {
            model.objectID.uriRepresentation()
        }
        
        main.ascending = HomeDataSource.sort.ascending
        main.sort = HomeDataSource.sort.key
        main.loop = PlayerManager.loop.rawValue
        main.playTime = PlayerManager.currentPlayerTime
        
        try? CoreDataContext.save()
    }
}
