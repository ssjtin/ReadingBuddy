//
//  TagPickerView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 16/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class TagPickerView: UIView {
    
    weak var delegate: TagPickerDelegate?
    
    let picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.spacing = 15
        return sv
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20
        
        addSubviewUsingAutoLayout(picker, buttonStackView)
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(cancelButton)
        
        picker.topAnchor.constrain(to: self.topAnchor)
        picker.leadingAnchor.constrain(to: self.leadingAnchor)
        picker.trailingAnchor.constrain(to: self.trailingAnchor)
        picker.bottomAnchor.constrain(to: buttonStackView.topAnchor)
        
        buttonStackView.leadingAnchor.constrain(to: self.leadingAnchor)
        buttonStackView.trailingAnchor.constrain(to: self.trailingAnchor)
        buttonStackView.bottomAnchor.constrain(to: self.bottomAnchor)
        buttonStackView.heightAnchor.constrain(to: 75)
    }
    
    @objc private func confirmButtonPressed() {
        delegate?.confirmSelection()
    }
    
    @objc private func cancelButtonPressed() {
        delegate?.cancelPicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension Optional where Wrapped == TagPickerView {
    mutating func reset() {
        self?.removeFromSuperview()
        self = nil
    }
}
