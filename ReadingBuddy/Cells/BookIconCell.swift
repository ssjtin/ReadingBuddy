//
//  BookIconCellCollectionViewCell.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 20/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class BookIconCell: UICollectionViewCell {
    
    weak var delegate: BookCellDelegate?
    
    lazy var bookCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.borderWidth = 3
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleBookCoverLongPressed))
        gesture.minimumPressDuration = 1
        iv.addGestureRecognizer(gesture)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Copperplate", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Copperplate", size: 16)
        return label
    }()
    
    var bookCoverWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        addSubviewUsingAutoLayout(bookCoverImageView, titleLabel, authorLabel)
        bookCoverImageView.topAnchor.constrain(to: self.topAnchor)
        bookCoverImageView.centerXAnchor.constrain(to: self.centerXAnchor)
        bookCoverImageView.heightAnchor.constrain(to: 162)
        
        titleLabel.topAnchor.constrain(to: bookCoverImageView.bottomAnchor, with: 4)
        titleLabel.leadingAnchor.constrain(to: bookCoverImageView.leadingAnchor, with: 5)
        titleLabel.trailingAnchor.constrain(to: bookCoverImageView.trailingAnchor)
        titleLabel.heightAnchor.constrain(to: 15)
        
        authorLabel.topAnchor.constrain(to: titleLabel.bottomAnchor, with: 4)
        authorLabel.leadingAnchor.constrain(to: bookCoverImageView.leadingAnchor, with: 8)
        authorLabel.trailingAnchor.constrain(to: bookCoverImageView.trailingAnchor)
        authorLabel.heightAnchor.constrain(to: 15)
        
    }
    
    func renderCell(_with book: Book) {
        if let data = book.coverImageData {
            let image = UIImage(data: data)!
            let heightToWidthRatio = image.size.height / image.size.width
            bookCoverImageView.image = UIImage(data: data) ?? UIImage(named: Images.defaultBookImageName)
            bookCoverWidthConstraint = bookCoverImageView.widthAnchor.constrain(to: 162 / heightToWidthRatio)
            
        } else {
            bookCoverImageView.image = UIImage(named: "noPicture")
        }
        authorLabel.text = book.author
        titleLabel.text = book.title
    }
    
    @objc private func handleBookCoverLongPressed(sender: UILongPressGestureRecognizer) {
        guard sender.state == .ended else { return }
        if let image = bookCoverImageView.image {
            delegate?.showZoomedBookCover(usingImage: image)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
