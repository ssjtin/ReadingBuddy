//
//  OptionsCell.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 14/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

let optionCellIdentifier = "optionsCell"

class OptionsCell: UITableViewCell {
    
    let icon: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    private func configureViews() {
        addSubviewUsingAutoLayout(icon, titleLabel, captionLabel)
        
        icon.centerYAnchor.constrain(to: self.centerYAnchor)
        icon.leadingAnchor.constrain(to: self.leadingAnchor, with: 20)
        icon.heightAnchor.constrain(to: self.frame.height * 0.8)
        icon.widthAnchor.constrain(to: self.frame.height * 0.8)
        
        titleLabel.leadingAnchor.constrain(to: icon.trailingAnchor, with: 20)
        titleLabel.topAnchor.constrain(to: self.topAnchor)
        titleLabel.trailingAnchor.constrain(to: self.trailingAnchor, with: -20)
        titleLabel.heightAnchor.constrain(to: self.frame.height * 0.5)
        
        captionLabel.leadingAnchor.constrain(to: icon.trailingAnchor, with: 20)
        captionLabel.topAnchor.constrain(to: titleLabel.bottomAnchor)
        captionLabel.trailingAnchor.constrain(to: self.trailingAnchor, with: -20)
        captionLabel.bottomAnchor.constrain(to: self.bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderCell(withOptions option: (UIImage, String, String)) {
        icon.image = option.0
        titleLabel.text = option.1
        captionLabel.text = option.2
    }
    
}
