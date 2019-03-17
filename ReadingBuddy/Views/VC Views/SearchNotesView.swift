//
//  SearchNotesView.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 3/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class SearchNotesView: UIView {
    
    weak var delegate: SearchNoteDelegate?
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        return sb
    }()
    
    let searchOptionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.layoutMargins = UIEdgeInsets(top: 5, left: 40, bottom: 5, right: 40)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    lazy var headlineOptionButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Headline ", for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(headlineOptionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var contentOptionButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Content ", for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(contentOptionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var tagSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Search by tag ", for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(tagSearchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let resultsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: UITableView.Style.plain)
        tv.register(NoteCell.self, forCellReuseIdentifier: "resultCell")
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gray
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubviewUsingAutoLayout(searchBar,searchOptionsStackView, resultsTableView)
        
        searchBar.topAnchor.constrain(to: self.topAnchor)
        searchBar.leadingAnchor.constrain(to: self.leadingAnchor)
        searchBar.trailingAnchor.constrain( to: self.trailingAnchor)
        searchBar.heightAnchor.constrain(to: 50)
        
        searchOptionsStackView.topAnchor.constrain(to: searchBar.bottomAnchor)
        searchOptionsStackView.leadingAnchor.constrain(to: self.leadingAnchor)
        searchOptionsStackView.trailingAnchor.constrain(to: self.trailingAnchor)
        searchOptionsStackView.heightAnchor.constrain(to: 50)
        
        searchOptionsStackView.addArrangedSubview(headlineOptionButton)
        searchOptionsStackView.addArrangedSubview(contentOptionButton)
        searchOptionsStackView.addArrangedSubview(tagSearchButton)
        
        resultsTableView.topAnchor.constrain(to: searchOptionsStackView.bottomAnchor)
        resultsTableView.leadingAnchor.constrain(to: self.leadingAnchor)
        resultsTableView.trailingAnchor.constrain(to: self.trailingAnchor)
        resultsTableView.bottomAnchor.constrain(to: self.bottomAnchor)
    }
    
    @objc private func headlineOptionButtonPressed(sender: UIButton) {
        if headlineOptionButton.isSelected == false {
            set(optionButton: headlineOptionButton, to: true)
            set(optionButton: contentOptionButton, to: false)
        } else {
            set(optionButton: headlineOptionButton, to: false)
        }
        updateSearchScope()
    }
    
    private func set(optionButton: UIButton, to selectedState: Bool) {
        switch selectedState {
        case true:
            optionButton.isSelected = true
            optionButton.backgroundColor = UIColor.black
            optionButton.setTitleColor(UIColor.white, for: .normal)
        case false:
            optionButton.isSelected = false
            optionButton.backgroundColor = UIColor.white
            optionButton.setTitleColor(.black, for: .normal
            )
        }
    }
    
    @objc private func contentOptionButtonPressed(sender: UIButton) {
        if contentOptionButton.isSelected == false {
            set(optionButton: contentOptionButton, to: true)
            set(optionButton: headlineOptionButton, to: false)
        } else {
            set(optionButton: contentOptionButton, to: false)
        }
        updateSearchScope()

    }
    
    private func updateSearchScope() {
                if headlineOptionButton.isSelected == false && contentOptionButton.isSelected == false {
                    delegate?.setSearchScope(.All)
                } else if headlineOptionButton.isSelected == true {
                    delegate?.setSearchScope(.Headline)
                } else if contentOptionButton.isSelected == true {
                    delegate?.setSearchScope(.Content)
                }
    }
    
    @objc private func tagSearchButtonPressed() {
        delegate?.presentTagPicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
