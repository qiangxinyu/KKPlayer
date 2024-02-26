//
//  AudioModel+CoreDataProperties.swift
//  
//
//  Created by 强新宇 on 2024/2/9.
//
//

import Foundation
import CoreData


extension AudioModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioModel> {
        return NSFetchRequest<AudioModel>(entityName: "AudioModel")
    }
    @NSManaged public var length: Int64
    @NSManaged public var createTime: Int64
    @NSManaged public var relativePath: String?
    

    
    @NSManaged private(set) public var playCount: Int64
    @NSManaged private(set) var album: String?
    @NSManaged private(set) var albumLetters: String?
    @NSManaged private(set) var artist: String?
    @NSManaged private(set) var artistLetters: String?
    @NSManaged private(set) var artistSort: String?
    @NSManaged private(set) var letters: String?
    @NSManaged private(set) var name: String?
    @NSManaged private(set) var nameSort: String?
}



extension AudioModel : Identifiable {

}


extension AudioModel {
    func setName(_ newValue: String) {
        name = newValue
        length = Int64(newValue.count)
        letters = newValue.toPinyin().lowercased()
        nameSort = letters?.sortKey
    }


    func setAlbum(_ newValue: String) {
        album = newValue.removeErrorText()
        albumLetters = newValue.toPinyin().lowercased()
    }

    func setArtist(_ newValue: String) {
        artist = newValue.removeErrorText()
        artistLetters = newValue.toPinyin().lowercased()
        artistSort = artistLetters?.sortKey
    }

    /// 只有在初始导入的时候会用这个方法，所以不需要进行 save core data
    func setPlayCount(count: Int64) {
        playCount = count
    }
    
    func playCountAddOne() {
        playCount += 1
        try? CoreDataContext.save()
    }
    
}



