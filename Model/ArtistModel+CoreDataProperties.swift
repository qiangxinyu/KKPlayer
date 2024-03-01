//
//  ArtistModel+CoreDataProperties.swift
//  
//
//  Created by 强新宇 on 2024/3/1.
//
//

import Foundation
import CoreData


extension ArtistModel: CollectModel {
    func addToAudio(_ audio: AudioModel) {
        addToAudios(audio)
    }
    
    var type: CollectDataSource.Types { .Artist }

    func removeFromAudio(_ audio: AudioModel) {
        removeFromAudios(audio)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistModel> {
        return NSFetchRequest<ArtistModel>(entityName: "ArtistModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var audios: NSSet?

}

// MARK: Generated accessors for audios
extension ArtistModel {

    @objc(addAudiosObject:)
    @NSManaged public func addToAudios(_ value: NSManagedObject)

    @objc(removeAudiosObject:)
    @NSManaged public func removeFromAudios(_ value: NSManagedObject)

    @objc(addAudios:)
    @NSManaged public func addToAudios(_ values: NSSet)

    @objc(removeAudios:)
    @NSManaged public func removeFromAudios(_ values: NSSet)

}
