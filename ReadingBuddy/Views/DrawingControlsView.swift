//
//  DrawingControlsView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 8/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class DrawingControlsView: UIView {
    
    var delegate: DrawingControlsDelegate?
    
    let colorButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    let sizeButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var plusSizeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plusIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleIncreaseSize), for: .touchUpInside)
        return button
    }()
    
    let minusSizeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minusIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleDecreaseSize), for: .touchUpInside)
        return button
    }()
    
    let buttonColors: [UIColor] =
        [UIColor.black,
         UIColor.blue,
         UIColor.red,
         UIColor.green,
         UIColor.yellow]

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.gray
        
        addSubviewUsingAutoLayout(colorButtonStackView, sizeButtonStackView)
        colorButtonStackView.topAnchor.constrain(to: self.topAnchor)
        colorButtonStackView.leadingAnchor.constrain(to: self.leadingAnchor, with: 10)
        colorButtonStackView.bottomAnchor.constrain(to: self.bottomAnchor)
        colorButtonStackView.trailingAnchor.constrain(to: sizeButtonStackView.leadingAnchor)

        colorButtonStackView.backgroundColor = UIColor.gray
        
        sizeButtonStackView.topAnchor.constrain(to: self.topAnchor)
        sizeButtonStackView.trailingAnchor.constrain(to: self.trailingAnchor, with: -10)
        sizeButtonStackView.bottomAnchor.constrain(to: self.bottomAnchor)
        sizeButtonStackView.widthAnchor.constrain(to: 100)
        
        sizeButtonStackView.addArrangedSubview(plusSizeButton)
        sizeButtonStackView.addArrangedSubview(minusSizeButton)
        
        for color in buttonColors {
            let colorButton: UIButton = {
                let button = UIButton()
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.white.cgColor
                button.backgroundColor = color
                button.frame.size = CGSize(width: 50, height: 50)
                button.layer.masksToBounds = true
                return button
            }()
            
            colorButton.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
            colorButtonStackView.addArrangedSubview(colorButton)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func colorButtonPressed(sender: UIButton) {
        delegate?.handleColorSelected(_forColor: sender.backgroundColor!)
    }
    
    @objc func handleIncreaseSize() {
        delegate?.handleSize(.Increase)
    }
    
    @objc func handleDecreaseSize() {
        delegate?.handleSize(.Decrease)
    }

}
