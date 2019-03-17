//
//  NewNoteVC.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 26/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RealmSwift

class NoteVC: UIViewController {
    
    enum NoteMode: String {
        case Adding
        case Editing
        case Viewing
    }
    
    var noteView: NoteView!
    var bookId: String
    
    var noteMode: NoteMode {
        didSet {
            handleNoteMode()
        }
    }
    
    var snapshotVC: SnapshotHandlerVC?
    
    let tagCellIdentifier = "tagCell"
    
    var editingNote: Note?
    
    //Note properties
    var tagArray = [String]()
    var screenshot: UIImage? {
        didSet {
            noteView?.snapshotImageView.image = screenshot
        }
    }
    
    init(note: Note) {
        self.editingNote = note
        self.bookId = note.bookId
        self.noteMode = .Viewing
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    init(bookId: String) {
        self.bookId = bookId
        self.noteMode = .Adding
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setupBarButtons()
        setupViews()
        setupNavigationBar()
        handleNoteMode()
    }
    
    deinit {
        print("New note VC deinit")
    }
    
    private func handleNoteMode() {
        
        switch noteMode {
            
        case .Adding :
            navigationItem.title = "New note"
            navigationItem.rightBarButtonItems = [barButtons!.cameraButton, barButtons!.saveNoteButton]
            
        case .Editing :
            noteView?.switchEditingMode(_to: true)
            navigationItem.rightBarButtonItems = [barButtons!.updateButton, barButtons!.cameraButton]
            navigationItem.title = "Editing Note"
            navigationItem.leftBarButtonItem = barButtons!.cancelChangesButton
            
        case .Viewing :
            noteView?.switchEditingMode(_to: false)
            navigationItem.title = nil
            let editButton = barButtons!.editNoteButton
            navigationItem.rightBarButtonItems = [editButton]
            navigationItem.leftBarButtonItem = nil
        }
        
    }
    
    private func setupViews() {
        //Instantiate note view
        noteView = NoteView(frame: CGRect(origin: CGPoint(x: 0, y: 88), size: CGSize(width: view.frame.width, height: view.frame.height - 88)))
        noteView.delegate = self
        noteView.tagTextField.delegate = self
        //Setup tag collection view
        noteView.tagCollectionView.delegate = self
        noteView.tagCollectionView.dataSource = self
        noteView.tagCollectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellIdentifier)
        
        view.addSubview(noteView)
        
        if let note = editingNote {
            tagArray = Array(note.tags)
            noteView.render(_with: note)
            self.screenshot = noteView?.snapshotImageView.image
            isEditing = false
            
        } else {
            noteView.newTagButton.alpha = 1
        }
    }
    
    struct NoteViewBarButtons {
        let cameraButton: UIBarButtonItem
        let saveNoteButton: UIBarButtonItem
        let updateButton: UIBarButtonItem
        let cancelChangesButton: UIBarButtonItem
        let editNoteButton: UIBarButtonItem
    }
    
    var barButtons: NoteViewBarButtons?
    
    private func setupBarButtons() {
        barButtons = NoteViewBarButtons(
            cameraButton: UIBarButtonItem(image: UIImage(named: "cameraIcon")!, style: .plain, target: self, action: #selector(presentImagePicker)),
            saveNoteButton: UIBarButtonItem(image: UIImage(named: "checkmark")!, style: .plain, target: self, action: #selector(handleCreateNote)),
            updateButton: UIBarButtonItem(image: UIImage(named: "checkmark")!, style: .plain, target: self, action: #selector(handleUpdateNote)),
            cancelChangesButton: UIBarButtonItem(title: "Discard changes", style: .plain, target: self, action: #selector(cancelChanges)),
            editNoteButton: UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(enterEditingMode)))
    }
    
    private func setupNavigationBar() {}
    
    func presentSnapshotHandler(_usingImage image: UIImage) {
        
        snapshotVC = SnapshotHandlerVC(snapshot: image)
        switch noteMode {
        case .Viewing: snapshotVC?.isEditingMode = false
        case .Adding, .Editing: snapshotVC?.isEditingMode = true
        }
        snapshotVC?.imageEditingDelegate = self
        navigationController?.pushViewController(snapshotVC!, animated: true)
    }
    
    //MARK: Handler functions
    
    @objc private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func enterEditingMode() {
        noteMode = .Editing
    }
    
    @objc private func handleCreateNote() {
        guard let headlineText = noteView?.headlineTextField.text,
             let contentText = noteView?.contentTextView.text,
             let imageData = screenshot?.pngData() else
        { return }
        
        let note = Note(bookId: bookId, headline: headlineText, content: contentText, pageImage: imageData, tagsArray: tagArray)
        
        let realmClass = RealmClass.shared
        realmClass.create(note)
    
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleUpdateNote() {
        
        guard let headlineText = noteView?.headlineTextField.text,
            let contentText = noteView?.contentTextView.text,
            let imageData = screenshot?.pngData() else
        {
            return
        }
        
        let realmClass = RealmClass.shared
        let tagList = List<String>()
        for tag in tagArray {
            tagList.append(tag)
        }
        realmClass.update(editingNote!, with: ["headline": headlineText, "content": contentText, "pageImage": imageData, "tags": tagList])
        
        isEditing = false
    }
    
    @objc private func cancelChanges() {
        if let note = editingNote {
            noteView.render(_with: note)
        }
        noteMode = .Viewing
    }

}

extension NoteVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newScreenshot: UIImage?
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newScreenshot = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newScreenshot = image
        }
        
        dismiss(animated: true) {
            if let screenshot = newScreenshot {
                self.screenshot = screenshot
                self.presentSnapshotHandler(_usingImage: screenshot)
            }
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NoteVC: ImageEditingDelegate {
    
    func save(_editedImage image: UIImage) {
        screenshot = image
    }
    
}

extension NoteVC: AddNoteDelegate {

    func handleSnapshotTapped() {
        
        guard let screenshot = screenshot else { return }
        presentSnapshotHandler(_usingImage: screenshot)
        
    }
    
}

extension NoteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdentifier, for: indexPath) as! TagCell
        cell.textLabel.text = tagArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tagArray[indexPath.row]
        
        let size = CGSize(width: 500, height: 50)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
        let estimatedFrame = NSString(string: tag).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: estimatedFrame.width + 10, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    

}

extension NoteVC: UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Disable whitespaces in tag text field
        if (string == " ") {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == noteView.tagTextField {

            if let tag = noteView.tagTextField.text {
                tagArray.append(tag.replacingOccurrences(of: " ", with: ""))
                noteView.tagCollectionView.reloadData()
            }
            
            noteView.hideTagTextField()
            
        }
        return true
    }
    
}
