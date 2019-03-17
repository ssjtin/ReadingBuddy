//
//  PopoverOptionsVC.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 13/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class PopoverOptionsVC: UIViewController {
    
    typealias optionTuple = (image: UIImage, title: String, caption: String)
    
    var options = [optionTuple]()
    
    let popoverFrame: CGRect
    let itemIndex: Int
    
    var delegate: OptionsDelegate?
    
    let popoverTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.black
        tv.isScrollEnabled = false
        return tv
    }()
    
    init(frame: CGRect, itemIndex: Int) {
        self.popoverFrame = frame
        self.itemIndex = itemIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureOptions()
        
        configureTableView()
    }
    
    
    private func configureOptions() {
        options.append((#imageLiteral(resourceName: "editIcon"), "Modify", "Make changes to this note"))
        options.append((#imageLiteral(resourceName: "deleteIcon"), "Delete", "Delete this note permanently"))
    }
    
    private func configureTableView() {
        
        popoverTableView.frame = view.frame
        view.addSubview(popoverTableView)
        popoverTableView.register(OptionsCell.self, forCellReuseIdentifier: optionCellIdentifier)
        popoverTableView.delegate = self
        popoverTableView.dataSource = self
    }

}

extension PopoverOptionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionCellIdentifier) as! OptionsCell
        
        cell.renderCell(withOptions: options[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height / CGFloat(options.count))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: ()
        case 1: delegate?.deleteNote(atIndex: itemIndex)
        default: ()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
