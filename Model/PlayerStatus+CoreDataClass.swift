//
//  PlayerStatus+CoreDataClass.swift
//  
//
//  Created by 强新宇 on 2024/2/9.
//
//

import Foundation
import CoreData

@objc(PlayerStatus)
public class PlayerStatus: NSManagedObject {

    static var main: PlayerStatus = {
        if let item = try? CoreDataContext.fetch(fetchRequest()).first {
            return item
        }
        
        return PlayerStatus(context: CoreDataContext)
    }()
    
    
    
    
    var ttt: TimeInterval = 0

}
