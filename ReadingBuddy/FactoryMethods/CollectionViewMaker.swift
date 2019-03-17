//
//  CollectionViewMaker.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 21/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

struct CollectionViewMaker {
    
    static func makeBookListCV(ofSize size: CGSize, with cellIdentifier: String) -> UICollectionView {
        
        let collectionView = UICollectionView(frame: CGRect(origin: .zero, size: size), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(BookIconCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }
    
}
