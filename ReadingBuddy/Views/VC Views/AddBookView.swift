//
//  NewBookView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 21/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class AddBookView: UIView {
    
    weak var delegate: AddBookDelegate?
    
    let bookCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var addCoverButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        button.setImage(UIImage(named: "cameraIcon"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(addCoverButtonClicked), for: .touchUpInside)
        return button
    }()

    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title"
        tf.borderStyle = .line
        tf.backgroundColor = UIColor.white
        tf.autocapitalizationType = .words
        tf.setBothSidesPaddingPoints(10)
        return tf
    }()
    
    let authorTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Author"
        tf.borderStyle = .line
        tf.backgroundColor = UIColor.white
        tf.autocapitalizationType = .words
        tf.setBothSidesPaddingPoints(10)
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightText
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        
        addSubviewUsingAutoLayout(titleTextField, authorTextField, addCoverButton, bookCoverImageView)
        
        titleTextField.topAnchor.constrain(to: self.topAnchor, with: 20)
        titleTextField.leadingAnchor.constrain(to: self.leadingAnchor)
        titleTextField.trailingAnchor.constrain(to: self.trailingAnchor)
        titleTextField.heightAnchor.constrain(to: 60)
        
        authorTextField.topAnchor.constrain(to: titleTextField.bottomAnchor, with: 20)
        authorTextField.leadingAnchor.constrain(to: self.leadingAnchor)
        authorTextField.trailingAnchor.constrain(to: self.trailingAnchor)
        authorTextField.heightAnchor.constrain(to: 60)
        
        addCoverButton.topAnchor.constrain(to: authorTextField.bottomAnchor, with: 50)
        addCoverButton.centerXAnchor.constrain(to: self.centerXAnchor)
        addCoverButton.widthAnchor.constrain(to: 70)
        addCoverButton.heightAnchor.constrain(to: 70)
        addCoverButton.layer.cornerRadius = 35
        
        bookCoverImageView.topAnchor.constrain(to: addCoverButton.bottomAnchor, with: 20)
        bookCoverImageView.leadingAnchor.constrain(to: self.leadingAnchor, with: 25)
        bookCoverImageView.trailingAnchor.constrain(to: self.trailingAnchor, with: -25)
        bookCoverImageView.bottomAnchor.constrain(to: self.bottomAnchor, with: -25)
    }
    
    @objc private func addCoverButtonClicked() {
        delegate?.addBookCoverImage()
    }
}
