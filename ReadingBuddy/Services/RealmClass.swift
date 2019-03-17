//
//  RealmClass.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 23/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

final class RealmClass: RealmDelegate {
    
    var notificationToken: NotificationToken?
    
    static let shared = RealmClass()

    weak var delegate: RealmDelegate?
    
    var books: Results<Book>? {
        didSet {
            print("new set of objects fetched")
        }
    }
    
    private init() {
        delegate = self
        print("init")
        if let bookObjects = delegate?.fetchObjectsFromRealm() {
            books = bookObjects
        }
        
    }
    
    func observeObjects(_ handler: @autoclosure @escaping () -> Void) {
        notificationToken = delegate?.realm.observe({ (notification, realm) in
            handler()
        })
    }
    
}
