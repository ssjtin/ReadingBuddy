//
//  Book.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 20/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

class Book: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var coverImageData: Data?
    
    convenience init(title: String, author: String, coverImageData: Data?) {
        self.init()
        
        self.id = UUID().uuidString.lowercased()
        self.title = title
        self.author = author
        self.coverImageData = coverImageData ?? nil
    }

}
