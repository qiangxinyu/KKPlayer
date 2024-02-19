//
//  AudioFileQueue.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/7.
//

import Foundation

import AVKit
import ID3TagEditor
import CoreData


/// 导入歌曲 文件管理
/// 文件命名格式：   歌名_歌手

class AudioFileQueue {
    private init() {}
    private static var queues = [URL]()
    private static var nextQueues = [URL]()
    
    private static let queue = DispatchQueue(label: "com.concurrentqueue", attributes: .concurrent)

    private static let timeout: TimeInterval = 0.4
    private static var isStartQueue = false
    
    
    static func push(audio: URL) {
        nextQueues.append(audio)
        handleQueues()
    }
    
    static func push(audioList: [URL]) {
        nextQueues += audioList
        handleQueues()
    }
    
    private static func handleQueues() {
        if isStartQueue { return }
        isStartQueue = true
        
        queue.asyncAfter(deadline: .now() + timeout) {
            queues = nextQueues
            nextQueues.removeAll()
            AudioFileQueue.addAudio(urls: queues)
            queues.removeAll()
            isStartQueue = false
            
            queue.asyncAfter(deadline: .now() + timeout) {
                if nextQueues.count > 0 {
                    handleQueues()
                }
            }
        }
    }
    
  
    

    
    private static let semaphore = DispatchSemaphore(value: 1)
    
    private static func checkAudio(
        _ url: URL,
        fileName: String? = nil,
        success: @escaping (String) -> Void,
        fail: @escaping () -> Void
    ) {
        guard url.lastPathComponent.hasSuffix(".mp3") else {
            fail()
            return
        }
        
        var audioFileName = fileName ?? url.lastPathComponent
        audioFileName = audioFileName.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\"", with: "'")
        
        let savePath = KKFileManager.Path.audio(component: audioFileName)
        var audioName = audioFileName.removeMP3().removeErrorText()
        audioName = audioName.components(separatedBy: "_").first ?? audioName
        
        
        if KKFileManager.fileExists(path: savePath) {
            
            UIAlertController.showDeleteAlert1(title: "《\(audioName)》已存在") {_ in
                DispatchQueue.global().async {
                    //replace
                    do {
                        let request = AudioModel.fetchRequest()
                        
                        request.predicate = NSPredicate(format: "relativePath = %@", savePath.relativePath)
                        
                        let list = try CoreDataContext.fetch(request)
                        
                        if list.count == 1 {
                            list[0].clearDisk()
                            DispatchQueue.main.async {
                                CoreDataContext.delete(list[0])
                            }
                        } else {
                            UIAlertController.show(title: "数据库有误") { _ in
                                fail()
                            }
                        }
                    } catch {
                        
                    }
                    
                    guard KKFileManager.moveFile(path: url.path, toPath: savePath) else {
                        UIAlertController.show(title: "文件添加失败") { _ in
                            fail()
                        }
                        return
                    }
                    success(audioFileName)
                }
                
            } sureBlock1: { _ in
                // rename
                let time = Int(Date().timeIntervalSince1970 * 1000)
                checkAudio(url, fileName: "\(audioName)_\(time).mp3", success: success, fail: fail)
            } cancelBlock: { _ in
                KKFileManager.removeFile(path: url.relativePath)
                fail()
            }
        } else {
            guard KKFileManager.moveFile(path: url.path, toPath: savePath) else {
                UIAlertController.show(title: "文件添加失败") { _ in
                    fail()
                }
                return
            }
            success(audioFileName)
        }
    }
    
    
    private static func createAudioModel(url: URL, next: @escaping () -> Void) {
        checkAudio(url) { audioFileName in
            
            let model = AudioModel(context: CoreDataContext)
            
            let name = audioFileName.removeMP3().removeErrorText()
            let nameArtist = name.components(separatedBy: "_")
            
            
            model.setName(nameArtist.first ?? name)
            model.createTime = Int64(Date().timeIntervalSince1970 * 1000)
            model.relativePath = name + ".mp3"
            
            
            do {
                let id3TagEditor = ID3TagEditor()
                let tag = try id3TagEditor.read(from: model.path.rawValue)
                
                if let album = (tag?.frames[.album] as? ID3FrameWithStringContent)?.content {
                    model.setAlbum(album.replacingOccurrences(of: "\"", with: "'"))
                }
                if let artist = (tag?.frames[.artist] as? ID3FrameWithStringContent)?.content {
                    model.setArtist(artist.replacingOccurrences(of: "\"", with: "'"))
                }
                if let artist = (tag?.frames[.artist] as? ID3FrameWithStringContent)?.content {
                    model.setArtist(artist.replacingOccurrences(of: "\"", with: "'"))
                }
                if let lyricist = (tag?.frames[.lyricist] as? ID3FrameWithStringContent)?.content {
                    model.lyrics = lyricist
                }
                
                if let data = (tag?.frames[.attachedPicture(.frontCover)] as? ID3FrameAttachedPicture)?.picture {
                    model.setOriginalArtwork(UIImage(data: data))
                }
                
                if let data = (tag?.frames[.attachedPicture(.other)] as? ID3FrameAttachedPicture)?.picture {
                    model.setOriginalArtwork(UIImage(data: data))
                }
            } catch { }
            
            
            if (model.artist ?? "").isEmpty, nameArtist.count == 2 {
                model.setArtist(nameArtist.last)
            }
            
                        
            next()
        } fail: {
            next()
        }
    }
    
    private static func addAudio(urls: [URL]) {
        for url in urls {
            semaphore.wait()
            createAudioModel(url: url) {
                semaphore.signal()
            }
        }
        
        
        DispatchQueue.main.async {
            do {
                try CoreDataContext.save()
                HomeDataSource.refreshItems()
            } catch {
                UIAlertController.show(title: "数据库写入失败 \(error.localizedDescription)")
            }
        }
    }
   
}
