//
//  NewBookVC.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 19/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class AddBookVC: UIViewController, UINavigationControllerDelegate {
    
    var coverImage: UIImage?
    var addBookView: AddBookView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
    }
    
    deinit {
        print("Deinit AddBookVC")
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.gray
        
        addBookView = AddBookView(frame: CGRect(origin: CGPoint(x: 0, y: 88), size: CGSize(width: view.frame.width, height: view.frame.height - 88)))
        addBookView.delegate = self
        view.addSubview(addBookView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "New book"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBook))
    }
    
    @objc func saveBook() {
        
        guard let bookTitle = addBookView?.titleTextField.text, let bookAuthor = addBookView?.authorTextField.text else { return }
        guard bookTitle != "" else { return }
        
        let newBook = Book(title: bookTitle, author: bookAuthor, coverImageData: coverImage?.pngData() ?? nil)
        
        let realmService = RealmClass.shared
        realmService.create(newBook)
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddBookVC: AddBookDelegate {

    func addBookCoverImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension AddBookVC: ImageEditingDelegate {
    func save(_editedImage image: UIImage) {
        coverImage = image
        addBookView.bookCoverImageView.image = image
    }
}

extension AddBookVC: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            coverImage = originalImage
        }
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            coverImage = editedImage
        }
        
        dismiss(animated: true) { [unowned self] in
            let imageEditVC = ImageEditVC(snapshot: self.coverImage!)
            imageEditVC.delegate = self
            self.navigationController?.pushViewController(imageEditVC, animated: true)
        }
        
    }
    
}

extension AddBookVC: UITextFieldDelegate {
    
}
