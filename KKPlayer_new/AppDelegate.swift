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


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Player.regist()
        KKFileManager.regist()

        registRotate()
 
        IQKeyboardManager.shared.enable = true

        kMainWindow.rootViewController = isPad ? IPadHomeViewController() : HomeViewController.shared
        kMainWindow.backgroundColor = .black
        kMainWindow.makeKeyAndVisible()
        
        
        if isPhone {
            PlayerMiniControl.regist()
        }

        restorePlayerStatus()
        
        
        
        return true
    }
    
    // MARK: UIDevice orientation
    
    @objc func didRotate() {
        refreshScreenInfo()
    }
    
    private func registRotate() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    // MARK: Open url

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if options[.openInPlace] != nil {
            AudioFileQueue.push(audio: url)
        }
        
        return true
    }
    
   
    // MARK: App Out
    func applicationWillTerminate(_ application: UIApplication) {
        PlayerStatus.save()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        PlayerStatus.save()
    }

    
    // MARK: restore
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



// MARK: Core Data

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


