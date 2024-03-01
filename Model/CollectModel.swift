//
//  CollectModel+CoreDataProperties.swift
//  
//
//  Created by 强新宇 on 2024/3/1.
//
//

import UIKit
import CoreData

protocol CollectModel {
    var name: String? { get set }
    var audios: NSSet? { get set }
    var type: CollectDataSource.Types { get }
    
    func addToAudio(_ audio: AudioModel)
    func removeFromAudio(_ audio: AudioModel)
}

extension CollectModel {
    var list: [AudioModel] {
        audios?.allObjects as! [AudioModel]
    }
    
    var iconPath: KKFileManager.Path {
        KKFileManager.Path.image(component: "\(name!)_\(type.rawValue)_s")
    }
    
    var originIoncPath: KKFileManager.Path {
        KKFileManager.Path.image(component: "\(name!)_\(type.rawValue)")
    }
    
    
    var iconImage: UIImage? {
        MemoryCache.getImage(path: iconPath)
    }
    
    var originIconImage: UIImage? {
        MemoryCache.getImage(path: originIoncPath)
    }
    
    func pushAudio(_ audio: AudioModel) {
        if audio.originalArtworkImage != nil {
            KKFileManager.copyFile(path: audio.originArtworkPath, toPath: originIoncPath)
            KKFileManager.copyFile(path: audio.artworkPath, toPath: iconPath)

        }
        addToAudio(audio)
    }
  
    
}

