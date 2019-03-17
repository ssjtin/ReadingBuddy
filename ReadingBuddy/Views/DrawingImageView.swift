//
//  DrawingImageView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 6/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

struct Line {
    
    var points: [CGPoint]
    var color: CGColor = UIColor.black.cgColor
    var width: CGFloat = 1.0
    
    init() {
        self.points = [CGPoint]()
    }
    
    init(points: [CGPoint]) {
        self.points = points
    }
}

class DrawingImageView: UIImageView {
    
    let originalImage: UIImage

    var lastPoint: CGPoint!
    
    var lines = [Line]()
    var currentLine: Line?
    
    var lineWidth: CGFloat = 1.0
    var lineColor: CGColor = UIColor.black.cgColor
    
    init(image: UIImage) {
        self.originalImage = image
        super.init(image: image)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
            currentLine = Line()
            currentLine?.color = lineColor
            currentLine?.width = lineWidth
            currentLine?.points.append(touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            currentLine?.points.append(currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let line = currentLine {
            lines.append(line)
            currentLine = nil
        }
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        //Set up draw context
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.image?.draw(in: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        //Add line
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        //Line settings
        context?.setLineCap(.round)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor)
        //Stroke and end context
        context?.strokePath()
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func drawStroke(forLine line: Line) {
        for (pointNumber, _) in line.points.enumerated() {
            guard pointNumber < (line.points.count - 1) else { break }
            drawLineFrom(line.points[pointNumber], toPoint: line.points[pointNumber+1])
        }
    }
    
    func redraw() {
        //Reset to original snapshot
        image = originalImage
        //Keep reference to current draw settings
        let setLineColor = self.lineColor
        let setLineWidth = self.lineWidth
        //Redraw lines
        lines.forEach { (line) in
            self.lineColor = line.color
            self.lineWidth = line.width
            drawStroke(forLine: line)
        }
        //Reset to latest draw settings
        self.lineColor = setLineColor
        self.lineWidth = setLineWidth
    }

}
