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
    @NSManaged public var id: Int64
    @NSManaged public var length: Int64
    @NSManaged public var createTime: Int64
    @NSManaged public var playCount: Int64
    @NSManaged public var relativePath: String?
    @NSManaged public var artwork: Data?

    
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


    func setAlbum(_ newValue: String?) {
        album = newValue
        albumLetters = newValue?.toPinyin().lowercased()
    }

    func setArtist(_ newValue: String?) {
        artist = newValue
        artistLetters = newValue?.toPinyin().lowercased()
        artistSort = artistLetters?.sortKey
    }


    private var smallArtworkName: String {
        get {"\(String(describing: createTime))_s"}
    }
    
    
    
    func changeValues(newModel: AudioModel) {
        id = newModel.id
        createTime = newModel.createTime
        relativePath = newModel.relativePath
        playCount = newModel.playCount
        
        name = newModel.name
        album = newModel.album
        artist = newModel.artist
        albumLetters = newModel.albumLetters
        length = newModel.length
        nameSort = newModel.nameSort
        letters = newModel.letters
        artistSort = newModel.artistSort
        artistLetters = newModel.artistLetters
    }
}



