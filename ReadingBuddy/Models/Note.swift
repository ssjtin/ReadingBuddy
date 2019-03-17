//
//  Note.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 25/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

class Note: Object {
    
    @objc dynamic var bookId: String = ""
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var headline: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var pageImage: Data?
    var tags = List<String>()
    
    convenience init(bookId: String, headline: String, content: String, pageImage: Data?, tagsArray: [String]) {
        self.init()
        
        self.bookId = bookId
        self.headline = headline
        self.content = content
        self.pageImage = pageImage

        for tag in tagsArray { self.tags.append(tag) }
    }
    
}
