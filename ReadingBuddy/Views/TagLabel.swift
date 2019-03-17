//
//  TagLabel.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 26/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class TagLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_with string: String) {
        text = string
        sizeToFit()
        updateConstraints()
    }
    
}
