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
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        
        IQKeyboardManager.shared.enable = true
        
        kMainWindow.rootViewController = HomeViewController.shared
        kMainWindow.backgroundColor = .B01
        kMainWindow.makeKeyAndVisible()
        
        
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
//        UserDefaultsUtils.playAudioTime = KKPlayer.currentTime
        UserDefaultsUtils.synchronize()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaultsUtils.synchronize()
    }

    

}

