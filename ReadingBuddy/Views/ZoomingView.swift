//
//  ZoomingView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 28/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class ZoomingView: UIView {
    
    let startingFrame: CGRect
    let zoomingImage: UIImage
    
    let zoomingImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.red
        view.isUserInteractionEnabled = true
        return view
    }()
    
    init(startingFrame: CGRect, zoomingImage: UIImage, frame: CGRect) {
        
        self.startingFrame = startingFrame
        self.zoomingImage = zoomingImage
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        alpha = 0
        
        zoomingImageView.frame = startingFrame
        zoomingImageView.image = zoomingImage
        
        addSubview(zoomingImageView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func zoomIn() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            let height = self.startingFrame.height / self.startingFrame.width * self.frame.width
            self.zoomingImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: height)
            self.zoomingImageView.center = self.center
            self.alpha = 1
            
        }, completion: nil)
        
    }
    
    func zoomOut() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.alpha = 0
            self.zoomingImageView.frame = self.startingFrame
            
        }) { (true) in
            self.removeFromSuperview()
        }
        
    }

}
