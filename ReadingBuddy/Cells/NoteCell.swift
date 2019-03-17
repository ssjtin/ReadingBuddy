//
//  NoteTableViewCell.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 5/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    var imageData: Data?
    weak var delegate: NoteCellDelegate?
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Symbol", size: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Symbol", size: 14)
        label.layer.cornerRadius = 8
        return label
    }()
    
    lazy var textIconButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "textIcon")!, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleTextIconPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "moreIcon")!, for: .normal)
        button.addTarget(self, action: #selector(handleOptionsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var tagLabelWidthConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviewUsingAutoLayout(textIconButton, headlineLabel, tagLabel, optionsButton)
        
        textIconButton.centerYAnchor.constrain(to: self.centerYAnchor)
        textIconButton.leadingAnchor.constrain(to: self.leadingAnchor, with: 10)
        textIconButton.heightAnchor.constrain(to: self.frame.height * 0.8)
        textIconButton.widthAnchor.constrain(to: self.frame.height * 0.8)
        
        textIconButton.layer.cornerRadius = self.frame.height * 0.4
        textIconButton.layer.masksToBounds = true
        
        headlineLabel.topAnchor.constrain(to: self.topAnchor, with: 10)
        headlineLabel.leadingAnchor.constrain(to: textIconButton.trailingAnchor, with: 10)
        headlineLabel.heightAnchor.constrain(to: self.frame.height * 0.5)
        headlineLabel.trailingAnchor.constrain(to: optionsButton.trailingAnchor, with: -5)
        
        tagLabel.topAnchor.constrain(to: headlineLabel.bottomAnchor, with: 5)
        tagLabel.leadingAnchor.constrain(to: headlineLabel.leadingAnchor)
        tagLabelWidthConstraint = tagLabel.widthAnchor.constrain(to: 0)
        tagLabelWidthConstraint?.isActive = true
        
        tagLabel.bottomAnchor.constrain(to: self.bottomAnchor)
        
        optionsButton.trailingAnchor.constrain(to: self.trailingAnchor, with: -20)
        optionsButton.centerYAnchor.constrain(to: self.centerYAnchor)
        optionsButton.widthAnchor.constrain(to: 30)
        optionsButton.heightAnchor.constrain(to: 30)
        
    }
    
    func render(with note: Note) {
        headlineLabel.text = note.headline
        imageData = note.pageImage
        if note.tags.count > 0 {
            configureTagString(withTags: Array(note.tags))
        }
        if imageData == nil {
            textIconButton.isEnabled = false
            textIconButton.alpha = 0.3
        } else {
            textIconButton.isEnabled = true
            textIconButton.alpha = 1
        }
    }
    
    func configureTagString(withTags tags: [String]) {
        var tagString: String = " "
        for tag in tags {
            tagString.append("#" + tag + "  ")
        }
        tagLabel.text = tagString
        tagLabelWidthConstraint?.constant = tagString.width(withConstrainedHeight: tagLabel.frame.height, font: tagLabel.font)
    }
    
    @objc func handleTextIconPressed() {
        print("pressing1")
        if let imageData = imageData {
            delegate?.showZoomedPageSnapshot(imageData)
        }
        
    }
    
    @objc func handleOptionsButtonPressed(sender: UIButton) {
        delegate?.presentOptionsMenu(forCell: sender.tag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
