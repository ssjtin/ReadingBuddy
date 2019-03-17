//
//  SearchResultCell.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 4/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    let screenshotImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let bookDetailsLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviewUsingAutoLayout(screenshotImageView, headlineLabel, bookDetailsLabel)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        screenshotImageView.centerYAnchor.constrain(to: self.centerYAnchor)
        screenshotImageView.leadingAnchor.constrain(to: self.leadingAnchor)
        screenshotImageView.heightAnchor.constrain(to: self.frame.height * 0.8)
        screenshotImageView.widthAnchor.constrain(to: self.frame.height * 0.8)
        
        headlineLabel.topAnchor.constrain(to: self.topAnchor, with: 10)
        headlineLabel.leadingAnchor.constrain(to: screenshotImageView.trailingAnchor, with: 5)
        headlineLabel.trailingAnchor.constrain(to: self.trailingAnchor, with: -5)
        headlineLabel.heightAnchor.constrain(to: 30)
        
        bookDetailsLabel.topAnchor.constrain(to: headlineLabel.bottomAnchor)
        bookDetailsLabel.leadingAnchor.constrain(to: screenshotImageView.trailingAnchor, with: 5)
        bookDetailsLabel.trailingAnchor.constrain(to: self.trailingAnchor, with: -5)
        bookDetailsLabel.bottomAnchor.constrain(to: self.bottomAnchor, with: -5)
    }
    
    func render(with note: Note) {
        screenshotImageView.loadImageFromData(note.pageImage)
        headlineLabel.text = note.headline
        
    }

}
