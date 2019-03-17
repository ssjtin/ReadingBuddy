//
//  Protocols.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 10/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

enum SizeChange {
    case Increase
    case Decrease
}

protocol DrawingControlsDelegate: class {
    func handleColorSelected(_forColor color: UIColor)
    func handleSize(_ change: SizeChange)
}

protocol AddBookDelegate: class {
    func addBookCoverImage()
}

protocol AddNoteDelegate: class {
    func handleSnapshotTapped()
}

protocol NoteCellDelegate: class {
    func showZoomedPageSnapshot(_ data: Data)
    func presentOptionsMenu(forCell cell: Int)
}

protocol OptionsDelegate {
    func deleteNote(atIndex index: Int)
}

protocol BookCellDelegate: class {
    func showZoomedBookCover(usingImage image: UIImage)
}

protocol TagPickerDelegate: class {
    func cancelPicker()
    func confirmSelection()
}

protocol SearchNoteDelegate: class {
    func presentTagPicker()
    func setSearchScope(_ searchScope: NoteSearchScope)
}
