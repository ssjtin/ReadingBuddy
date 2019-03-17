//
//  GenericListDataSource.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 3/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

class ListDataSource<T: Object>: NSObject {
    
    let realmClass = RealmClass.shared
    var listResults: Results<T>?
    var notification: NotificationToken?
    
    func fetchResultsFromRealm(withPredicate predicate: NSPredicate) {
        listResults = realmClass.realm.objects(T.self).filter(predicate)
    }
    
    func observeResults(_ handler: @autoclosure @escaping () -> Void) {
        notification = realmClass.realm.observe({ (notification, realm) in
            handler()
        })
    }
    
    func deleteObject(object: T) {
        realmClass.delete(object)
    }
        
}
