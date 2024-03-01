//
//  MemoryCacheImages.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/3/1.
//

import UIKit


class MemoryCache {
    private static var MemoryCacheImages = [String: UIImage]()

    
    static func getImage(path: KKFileManager.Path) -> UIImage? {
        var image = MemoryCacheImages[path.relativePath]
        if image == nil, KKFileManager.fileExists(path: path) {
            image = UIImage(contentsOfFile: path.rawValue)
            setImage(image: image!, path: path)
        }
        
        return image
    }
    
    static func setImage(image: UIImage, path: KKFileManager.Path) {
        MemoryCacheImages[path.relativePath] = image
    }
}


