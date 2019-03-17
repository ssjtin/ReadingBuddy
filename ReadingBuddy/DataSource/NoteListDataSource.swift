//
//  NoteListDataSource.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 25/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

class NoteListDataSource<T: Note>: ListDataSource<Note>, UITableViewDataSource {
    
    let bookId: String
    var notes = [Note]()
    
    init(bookId: String) {
        self.bookId = bookId
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        let note = notes[indexPath.row]
        cell.render(with: note)
        
        return cell
    }
    
    func updateNotesArray() {
        if let results = listResults {
            notes = Array(results.filter { $0.bookId == self.bookId })
        }
    }

}
