//
//  AudioModel+CalculationProperty.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/7.
//

import Foundation
import UIKit
import AVFoundation

extension AudioModel {
    var lyricsPath: KKFileManager.Path {
        get {.lyrics(component: "\(createTime).txt")}
    }
    var lyrics: String? {
        set {
            KKFileManager.removeFile(path: lyricsPath)
            guard let text = newValue, text.count > 0 else {
                return
            }
            KKFileManager.createFile(path: lyricsPath, data: text.data(using: .utf8))
        }
        get {
            do {
                return try String(contentsOf: lyricsPath.url)
            } catch {
                return nil
            }
        }
    }
    
    
   
    var artworkImage: UIImage? {
        if let artwork = artwork {
            return UIImage(data: artwork)
        } else {
            return nil
        }
    }
   
    
    var originArtworkPath: KKFileManager.Path {
        KKFileManager.Path.image(component: String(createTime))
    }
    
  
    
    var originalArtworkImage: UIImage? {
        if KKFileManager.fileExists(path: originArtworkPath) {
            return UIImage(contentsOfFile: originArtworkPath.rawValue)
        } else {
            return nil
        }
    }
    
   
    func setOriginalArtwork(_ image: UIImage?) {
        guard let image = image else {return}
        
        KKFileManager.createFile(path: originArtworkPath, data: image.jpegData(compressionQuality: 1))
        
        var artwork: UIImage
        let size: CGFloat = 180
        if image.size.width > size || image.size.height > size {
            
            let maxSize = CGSize(width: size, height: size)
            let newSize = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: .zero, size: maxSize)).size
            artwork = UIGraphicsImageRenderer(size: newSize).image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
            
        } else {
            artwork = image
        }
        
        self.artwork = artwork.jpegData(compressionQuality: 1)
    }
    
    
    var path: KKFileManager.Path {
        KKFileManager.Path.audio(component: relativePath ?? "")
    }
    
    
    
    
    func clearDisk() {
        KKFileManager.removeFile(path: path)
        KKFileManager.removeFile(path: originArtworkPath)
        KKFileManager.removeFile(path: lyricsPath)
    }
}
