//
//  CollectionViewController.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 12/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        setupSubviews()
    }
    
    private func setupSubviews() {
    
        addSubviewUsingAutoLayout(textLabel, separator)
        textLabel.topAnchor.constrain(to: self.topAnchor)
        textLabel.leadingAnchor.constrain(to: self.leadingAnchor)
        textLabel.trailingAnchor.constrain(to: self.trailingAnchor)
        textLabel.bottomAnchor.constrain(to: self.bottomAnchor)
        
        separator.trailingAnchor.constrain(to: self.trailingAnchor)
        separator.topAnchor.constrain(to: self.topAnchor, with: 20)
        separator.bottomAnchor.constrain(to: self.bottomAnchor, with: -20)
        separator.widthAnchor.constrain(to: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
