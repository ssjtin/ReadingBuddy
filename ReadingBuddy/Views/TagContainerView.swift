//
//  TagContainerView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 26/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class TagContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTags(using tagsArray: [String]) {
        var lastTag: TagLabel?
        
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        for (number, tagString) in tagsArray.enumerated() {
            
            let label = TagLabel()
            label.isUserInteractionEnabled = true
            label.tag = number + 1
            
            label.setText(_with: " #" + tagString + " ")
            addSubview(label)
            
            if lastTag == nil {
                label.frame.origin = CGPoint(x: 10, y: 10)
                lastTag = label
            } else {
                label.frame.origin = CGPoint(x: lastTag!.frame.maxX + 10, y: 10)
                lastTag = label
            }
        }
    }

}
