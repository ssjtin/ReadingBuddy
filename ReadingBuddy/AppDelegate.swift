//
//  AppDelegate.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 19/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        migrateRealm()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: BookListVC())
        
        //Go straight to snapshot handler vc for testing
//        let vc = SnapshotHandlerVC(snapshot: UIImage(named: "eventBackground")!)
//        window?.rootViewController = UINavigationController(rootViewController: vc)
        
        
        
        return true
    }
    
    func migrateRealm() {
        var config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {

                    migration.enumerateObjects(ofType: Note.className()) { oldObject, newObject in
                        newObject!["book"] = Book(title: "migration book", author: "migrator", coverImageData: nil)
                        
                    }
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

