//
//  AlbumModel+CoreDataProperties.swift
//  
//
//  Created by 强新宇 on 2024/3/1.
//
//

import Foundation
import CoreData


extension AlbumModel: CollectModel {
 
    func addToAudio(_ audio: AudioModel) {
        addToAudios(audio)
    }
    func removeFromAudio(_ audio: AudioModel) {
        removeFromAudios(audio)
    }
    var type: CollectDataSource.Types { .Album }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumModel> {
        return NSFetchRequest<AlbumModel>(entityName: "AlbumModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var audios: NSSet?

}

// MARK: Generated accessors for audios
extension AlbumModel {

    @objc(addAudiosObject:)
    @NSManaged public func addToAudios(_ value: AudioModel)

    @objc(removeAudiosObject:)
    @NSManaged public func removeFromAudios(_ value: AudioModel)

    @objc(addAudios:)
    @NSManaged public func addToAudios(_ values: NSSet)

    @objc(removeAudios:)
    @NSManaged public func removeFromAudios(_ values: NSSet)

}
