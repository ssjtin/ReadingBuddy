//
//  BookDetailsView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 20/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class BookDetailsView: UIView {
    
    let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewDesign()
        setupViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewDesign() {
        backgroundColor = UIColor.blue
        layer.cornerRadius = LayoutConstants.BookDetailsViewConstants.cornerRadius
        
    }
    
    private func setupViewLayout() {
        
        addSubviewUsingAutoLayout(coverImageView, titleLabel, authorLabel)
        
        coverImageView.widthAnchor.constrain(to: self.frame.width * LayoutConstants.BookDetailsViewConstants.coverImageWidthConstraintMultiplier)
        coverImageView.heightAnchor.constrain(to: self.frame.height * LayoutConstants.BookDetailsViewConstants.coverImageHeightConstraintMultiplier)
        coverImageView.centerYAnchor.constrain(to: self.centerYAnchor)
        coverImageView.leadingAnchor.constrain(to: self.leadingAnchor, with: LayoutConstants.BookDetailsViewConstants.viewPadding)
        
        titleLabel.topAnchor.constrain(to: coverImageView.topAnchor)
        titleLabel.leadingAnchor.constrain(to: coverImageView.trailingAnchor, with: 20)
        titleLabel.heightAnchor.constrain(to: 25)
        titleLabel.trailingAnchor.constrain(to: self.trailingAnchor)
        
        authorLabel.topAnchor.constrain(to: titleLabel.bottomAnchor, with: 10)
        authorLabel.leadingAnchor.constrain(to: coverImageView.trailingAnchor, with: 20)
        authorLabel.heightAnchor.constrain(to: 25)
        authorLabel.trailingAnchor.constrain(to: self.trailingAnchor)
        
    }
    
    func loadBookInfo(_with book: Book) {
        if let data = book.coverImageData {
            coverImageView.image = UIImage(data: data)
        }
        titleLabel.text = book.title
        authorLabel.text = book.author
    }

}
