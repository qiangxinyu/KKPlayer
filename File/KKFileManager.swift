//
//  FIleManager.swift
//  Player
//
//  Created by 强新宇 on 2022/3/16.
//

import Foundation
import UIKit


let mainPath = NSHomeDirectory() + "/Documents/"

class KKFileManager {
    
    static let main = KKFileManager()
    
    private let manager = FileManager.default
    
    
    
    enum Path {
        typealias RawValue = String
        
        case audio(component: String = "")
        case image(component: String = "")
        case lyrics(component: String = "")
        case tmp(component: String = "")

        var rawValue: String {
            switch self {
            case .audio(let component):
                return mainPath + "Audio/" + component
            case .image(let component):
                return mainPath + "Image/" + component
            case .lyrics(let component):
                return mainPath + "Lyrics/" + component
            case .tmp(let component):
                return mainPath + "Tmp/" + component
            }
        }
        
        var url: URL {
            return URL(fileURLWithPath: rawValue)
        }
        
        var relativePath: String {
            
            switch self {
            case  .audio(let component),
                    .image(let component),
                    .lyrics(let component),
                    .tmp(let component):
                return component
            }
        }
    }
    
    static func regist() {
        craeteFolder(path: .audio())
        craeteFolder(path: .image())
        craeteFolder(path: .lyrics())
        craeteFolder(path: .tmp())

        print(mainPath)
    }
    
    
    static func fileExists(path: String) -> Bool {
        return main.fileExists(path: path)
    }
    func fileExists(path: String) -> Bool {
        return manager.fileExists(atPath: path)
    }
    
    static func fileExists(path: Path) -> Bool {
        return main.fileExists(path: path)
    }
    func fileExists(path: Path) -> Bool {
        return manager.fileExists(atPath: path.rawValue)
    }
    
    @discardableResult
    static func createFile(path: Path, data: Data? = nil) -> Bool {
        return main.createFile(path: path, data: data)
    }
    @discardableResult
    func createFile(path: Path, data: Data? = nil) -> Bool {
        if fileExists(path: path) {
            removeFile(path: path)
        }
        return manager.createFile(atPath: path.rawValue, contents: data)
    }
    
    @discardableResult
    static func craeteFolder(path: Path) -> Bool {
        return main.craeteFolder(path: path.rawValue)
    }
    @discardableResult
    func craeteFolder(path: Path) -> Bool {
        craeteFolder(path: path.rawValue)
    }
    
    @discardableResult
    static func craeteFolder(path: String) -> Bool {
        return main.craeteFolder(path: path)
    }
    @discardableResult
    func craeteFolder(path: String) -> Bool {
        if fileExists(path: path) {
            return false
        }
        do {
            try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    static func folderCount(path: String) -> Int {
        do {
            return try main.manager.contentsOfDirectory(atPath: path).count
        } catch {
            return 0
        }
    }
    
    static func clearEmptyFolder(path: String?) {
        guard let path = path else {
            return
        }

        if folderCount(path: path) == 0 {
            removeFile(path: path)
        }
    }
    
    @discardableResult
    static func copyFile(path: Path, toPath: Path) -> Bool {
        return main.copyFile(path: path.rawValue, toPath: toPath.rawValue)
    }
    @discardableResult
    static func copyFile(path: String, toPath: String) -> Bool {
        return main.copyFile(path: path, toPath: toPath)
    }
    func copyFile(path: String, toPath: String) -> Bool {
        if path == toPath || fileExists(path: toPath) {
            return false
        }
        do {
            try manager.copyItem(atPath: path, toPath: toPath)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    @discardableResult
    static func moveFile(path: Path, toPath: Path) -> Bool {
        return main.moveFile(path: path.rawValue, toPath: toPath)
    }
    @discardableResult
    static func moveFile(path: String, toPath: Path) -> Bool {
        return main.moveFile(path: path, toPath: toPath)
    }

    
    func moveFile(path: String, toPath: Path) -> Bool {
        if path == toPath.rawValue || fileExists(path: toPath) {
            return false
        }
        do {
            try manager.moveItem(atPath: path, toPath: toPath.rawValue)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    static func removeFile(path: Path) -> Bool {
        return main.removeFile(path: path)
    }
    
    @discardableResult
    func removeFile(path: Path) -> Bool {
        do {
            try manager.removeItem(atPath: path.rawValue)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    static func removeFile(path: String) -> Bool {
        return main.removeFile(path: path)
    }
    
    @discardableResult
    func removeFile(path: String) -> Bool {
        do {
            try manager.removeItem(atPath: path)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    func allURL(path: Path) -> [Path] {
        do {
            return try manager.contentsOfDirectory(atPath: path.rawValue).map { Path.audio(component: $0) }
        } catch {
            return []
        }
    }
    
}
