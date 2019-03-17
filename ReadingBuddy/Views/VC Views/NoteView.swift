//
//  NewNoteView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 25/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class NoteView: UIView {
    
    weak var delegate: AddNoteDelegate?
    weak var textFieldDelegate: UITextFieldDelegate?
    
    let headlineTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Summarize your note here"
        tf.font = UIFont(name: "Symbol", size: 20)
        tf.setBothSidesPaddingPoints(10)
        tf.borderStyle = .line
        tf.borderStyle = .bezel
        tf.backgroundColor = UIColor.white
        return tf
    }()
    
    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Symbol", size: 18)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.black.cgColor
        return tv
    }()
    
    lazy var newTagButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tag", for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.masksToBounds = true
        button.alpha = 0
        return button
    }()
    
    lazy var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let snapshotImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var tagTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add tag"
        tf.borderStyle = .roundedRect
        tf.setLeftPaddingPoints(10)
        tf.textAlignment = .left
        tf.addTarget(self, action: #selector(handleTagTextFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.groupTableViewBackground
        addSubviewUsingAutoLayout(headlineTextField, contentTextView, newTagButton, tagCollectionView, snapshotImageView)
        setupSubviews()
    }
    
    var newTagButtonHeightConstraint: NSLayoutConstraint?
    var tagTextFieldWidthConstraint: NSLayoutConstraint?
    
    private func setupSubviews() {
        headlineTextField.topAnchor.constrain(to: self.topAnchor, with: 10)
        headlineTextField.leadingAnchor.constrain(to: self.leadingAnchor)
        headlineTextField.trailingAnchor.constrain(to: self.trailingAnchor)
        headlineTextField.heightAnchor.constrain(to: 60)
        
        contentTextView.topAnchor.constrain(to: headlineTextField.bottomAnchor, with: 10)
        contentTextView.leadingAnchor.constrain(to: self.leadingAnchor)
        contentTextView.trailingAnchor.constrain(to: self.trailingAnchor)
        contentTextView.heightAnchor.constrain(to: 120)
        
        newTagButton.topAnchor.constrain(to: contentTextView.bottomAnchor, with: 10)
        newTagButton.centerXAnchor.constrain(to: self.centerXAnchor)
        newTagButtonHeightConstraint = newTagButton.heightAnchor.constrain(to: 50)
        newTagButton.widthAnchor.constrain(to: 50)
        newTagButton.layer.cornerRadius = 25
        newTagButton.addTarget(self, action: #selector(handleNewTagPressed), for: .touchUpInside)
        
        tagCollectionView.topAnchor.constrain(to: newTagButton.bottomAnchor, with: 10)
        tagCollectionView.trailingAnchor.constrain(to: self.trailingAnchor)
        tagCollectionView.leadingAnchor.constrain(to: self.leadingAnchor)
        tagCollectionView.heightAnchor.constrain(to: 60)
        
        snapshotImageView.topAnchor.constrain(to: tagCollectionView.bottomAnchor, with: 10)
        snapshotImageView.centerXAnchor.constrain(to: self.centerXAnchor)
        snapshotImageView.widthAnchor.constrain(to: self.frame.width - 20)
        snapshotImageView.heightAnchor.constrain(to: self.frame.width - 20)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(snapshotTapped))
        snapshotImageView.addGestureRecognizer(tapGesture)
        
        addSubviewUsingAutoLayout(tagTextField)
        tagTextField.centerXAnchor.constrain(to: self.centerXAnchor)
        tagTextField.heightAnchor.constrain(to: 60)
        
        tagTextFieldWidthConstraint = tagTextField.widthAnchor.constrain(to: 100)
        tagTextFieldCenterYConstraint = tagTextField.centerYAnchor.constrain(to: newTagButton.centerYAnchor, with: -500)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    
    func render(_with note: Note) {
        headlineTextField.text = note.headline
        contentTextView.text = note.content
        snapshotImageView.loadImageFromData(note.pageImage)
    }
    
    func switchEditingMode(_to mode: Bool) {
        headlineTextField.isUserInteractionEnabled = mode
        contentTextView.isUserInteractionEnabled = mode
        newTagButton.isUserInteractionEnabled = mode
        
        UIView.animate(withDuration: 0.5) {
            self.newTagButton.alpha = mode ? 1 : 0
        }
    }
    
    @objc private func snapshotTapped() {
        delegate?.handleSnapshotTapped()
    }
    
    @objc private func handleTagTextFieldDidChange() {
        //Adjust text field width constraint to text length
        if let text = tagTextField.text {
            let size = CGSize(width: 500, height: 60)
            let attributes = [NSAttributedString.Key.font: tagTextField.font!]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            tagTextFieldWidthConstraint?.isActive = false
            tagTextFieldWidthConstraint = tagTextField.widthAnchor.constrain(to: max(estimatedFrame.width + 40, 100.0))
        }
        //Remove whitespace
        if let text = tagTextField.text {
            tagTextField.text = text.replacingOccurrences(of: " ", with: "")
        }
    }
    
    var tagTextFieldCenterYConstraint: NSLayoutConstraint?
    
    @objc private func handleNewTagPressed() {
        
        UIView.animate(withDuration: 0.5) {
            self.newTagButton.alpha = 0
            self.tagTextFieldCenterYConstraint?.constant = 0
            
            self.layoutIfNeeded()
        }
        tagTextField.becomeFirstResponder()
    }
    
    func hideTagTextField() {
        tagTextField.text = nil
        UIView.animate(withDuration: 0.5) {
            self.newTagButton.alpha = 1
            self.tagTextFieldCenterYConstraint?.constant = -500
            
            self.layoutIfNeeded()
        }
    }
}
