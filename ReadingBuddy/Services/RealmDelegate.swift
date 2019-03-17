//
//  RealmObserverProtocol.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 22/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

protocol RealmDelegate : class {
  
    var realm: Realm { get }
    var notificationToken: NotificationToken? { get set }
    
    func fetchObjectsFromRealm() -> Results<Book>
    func create<T: Object>(_ object: T)
    func update<T: Object>(_ object: T, with dictionary: [String: Any?])
    func delete<T: Object>(_ object: T)
    func post(_ error: Error)
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void)
    func stopObservingErrors(in vc: UIViewController)
    
}

extension RealmDelegate {
    
    var realm: Realm {
        return try! Realm()
    }
    
    func fetchObjectsFromRealm() -> Results<Book> {
        return realm.objects(Book.self)
    }
    
    //MARK: Realm create
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    //MARK: Realm update
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    //MARK: Realm delete
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            post(error)
        }
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
}
