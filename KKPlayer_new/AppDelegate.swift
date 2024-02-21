//
//  AppDelegate.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SnapKit


var CoreDataContext: NSManagedObjectContext = {
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "KKPlayer_new")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    return persistentContainer.viewContext
}()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PlayerManager.regist()

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
 
        IQKeyboardManager.shared.enable = true
        
        kMainWindow.rootViewController = HomeViewController.shared
        kMainWindow.backgroundColor = .black
        kMainWindow.makeKeyAndVisible()
        
        restorePlayerStatus()
        
        
        if !UserDefaults.standard.bool(forKey: "11") {
            
            HomeDataSource.items.forEach {
                CoreDataContext.delete($0)
            }
            
            try? CoreDataContext.save()
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                
               let l = KKFileManager.main.allURL(path: .audio())

               var list = [URL]()
               l.forEach { url in
                   let toPath = KKFileManager.Path.tmp(component: url.relativePath)
                   KKFileManager.moveFile(path: url, toPath: toPath)
                   list.append(toPath.url)
               }
                
                list.forEach { url in
                    AudioFileQueue.push(audio: url)
                }

            }
            UserDefaults.standard.set(true, forKey: "11")
        }

        
        

        
        return true
    }
    
    
    // MARK: UIDevice orientation
    @objc func didRotate() {
        refreshScreenInfo()
    }
    
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if options[.openInPlace] != nil {
            AudioFileQueue.push(audio: url)
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PlayerStatus.save()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        PlayerStatus.save()
    }

    
    func restorePlayerStatus() {
        if let key = PlayerStatus.main.sort {
            HomeDataSource.sort = .init(key: key, ascending: PlayerStatus.main.ascending)
        }
        
        if let loop = PlayerList.Loop.init(rawValue: PlayerStatus.main.loop) {
            PlayerManager.loop = loop
        }
        
        guard
            let url = PlayerStatus.main.audioObjectID,
            let objectID = CoreDataContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)
        else {return}

        
        guard let item = try? CoreDataContext.existingObject(with: objectID) as? AudioModel else {return}
        
        PlayerManager.play(model: item, list: HomeDataSource.items)
        PlayerManager.pause()
        PlayerManager.seek(to: PlayerStatus.main.playTime)
    }
}


