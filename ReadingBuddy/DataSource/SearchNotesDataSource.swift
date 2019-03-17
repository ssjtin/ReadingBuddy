//
//  SearchNotesDataSource.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 3/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

class SearchNotesDataSource<T: Note>: ListDataSource<Note> {

    weak var tableView: UITableView?
    
    var filteredResults = [Note]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    func filterResults(using searchString: String, in searchScope: NoteSearchScope) {
        guard let notesFromRealm = listResults else { return }
        
        var results = [Note]()
        
        let (tags, searchWords) = parseWords(from: searchString)
        
        guard tags.count != 0 || searchWords.count != 0 else { return }
        
        if tags.count > 0 {
            results = Array(notesFromRealm).filter { Set($0.tags.map { $0.lowercased() }).isSuperset(of: tags) }
        } else {
            results = Array(notesFromRealm)
        }
        
        guard searchWords.count > 0 else { filteredResults = results; return }
       
        switch searchScope {
        case .All:
            filteredResults = results.filter {
               Set(($0.headline.lowercased() + " " + $0.content.lowercased()).components(separatedBy: NSCharacterSet.alphanumerics.inverted).filter { $0 != "" }).isSuperset(of: searchWords)
            }
        case .Headline:
            filteredResults = results.filter {
                Set(($0.headline.lowercased()).components(separatedBy: NSCharacterSet.alphanumerics.inverted).filter { $0 != "" }).isSuperset(of: searchWords)
            }
        case .Content:
            filteredResults = results.filter {
                Set(($0.content.lowercased()).components(separatedBy: NSCharacterSet.alphanumerics.inverted).filter { $0 != "" }).isSuperset(of: searchWords)
            }
        case .Tags:
            ()
        }
        
    }
    
    func parseWords(from searchString: String) -> ([String], [String]) {

        var tags = [String]()
        var searchWords = [String]()
        
        var fullString = searchString
        while fullString.contains("#") {
            if let hashtagIndex = fullString.firstIndex(of: "#") {
                let remainingSubstring = fullString[hashtagIndex...]
                if let endIndex = remainingSubstring.firstIndex(of: " ") {
                    tags.append(String(fullString[hashtagIndex..<endIndex].dropFirst()).lowercased())
                    fullString.removeSubrange(hashtagIndex...endIndex)
                } else {
                    tags.append(String(fullString[hashtagIndex...].dropFirst()).lowercased())
                    fullString = String(fullString[..<hashtagIndex])
                }
            }
        }
        searchWords = fullString.components(separatedBy: NSCharacterSet.alphanumerics.inverted).filter { $0 != "" }.map { $0.lowercased() }
 
        return (tags, searchWords)
    }
    
    func getTagList() -> [String] {
        guard let notes = listResults else { return [] }
        var tags = [String]()
        for note in notes {
            for tag in note.tags {
                tags.append(tag)
            }
        }
        return Array(Set(tags))
    }

}
