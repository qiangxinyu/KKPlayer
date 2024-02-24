//
//  AudioModel+CoreDataClass.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/5.
//
//

import UIKit
import CoreData
import ID3TagEditor

@objc(AudioModel)
public class AudioModel: NSManagedObject {

    
    /// 更新歌曲数据 包括文件内存储信息
    /// nil 为不改变的数据  所以都需要进行判断
    /// 单独更改不会很频繁，所以就不去开辟子线程执行了
    func update(name newName: String? = nil,
                artist newArtist: String? = nil,
                artwork newArtwork: UIImage? = nil,
                album newAlbum: String? = nil,
                lyrics newLyrics: String? = nil,
                autoSaveCoreData: Bool = true)
    {
        
        let id3Tag = ID32v4TagBuilder()

        
        /// 歌名不能为空
        if newName?.isEmpty == false {
            setName(newName!)
            _ = id3Tag.title(frame: ID3FrameWithStringContent(content: newName!))
        }
        
        if let newArtist = newArtist {
            setArtist(newArtist)
            _ = id3Tag.artist(frame: ID3FrameWithStringContent(content: newArtist))
        }
        
        if let newAlbum = newAlbum {
            setAlbum(newAlbum)
            _ = id3Tag.album(frame: ID3FrameWithStringContent(content: newAlbum))
        }
        
        if let newArtwork = newArtwork {
            setOriginalArtwork(newArtwork)
            
            if let data = newArtwork.jpegData(compressionQuality: 1) {
                _ = id3Tag.attachedPicture(
                    pictureType: .frontCover,
                    frame: ID3FrameAttachedPicture(picture: data, type: .frontCover, format: .jpeg))
            }
        }
     
        if let newLyrics = newLyrics {
            lyrics = newLyrics
            _ = id3Tag.lyricist(frame: ID3FrameWithStringContent(content: newLyrics))
        }
                
        try? ID3TagEditor().write(tag: id3Tag.build(), to: path.rawValue)

        renameFile()
        
        if autoSaveCoreData {
            try? CoreDataContext.save()
        }
    }
    
    func renameFile() {
        let newRelativePath = "\(name ?? "")_\(artist ?? "").mp3"

        let newPath = newRelativePath.replacingOccurrences(of: "/", with: "&")
        KKFileManager.moveFile(path: path, toPath: .audio(component: newPath))
        
        relativePath = newRelativePath
    }
}
