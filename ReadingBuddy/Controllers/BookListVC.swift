//
//  ViewController.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 19/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class BookListVC: UIViewController {
    
    var booksCollectionView: UICollectionView?
    
    private let dataSource = ListDataSource<Book>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        setupViews()
        setupNavigationBar()
    }
    
    deinit {
        print("book list VC deinit")
    }
    
    //Setup functions
    
    private func setupDataSource() {
        dataSource.fetchResultsFromRealm(withPredicate: NSPredicate(value: true))
        let handler = { [unowned self] in
            self.booksCollectionView!.reloadData()
        }
        dataSource.observeResults(handler())
    }
    
    private func setupViews() {
        let backgroundImageView = UIImageView(image: UIImage(named: "eventBackground")!)
        backgroundImageView.frame = view.frame
        view.addSubview(backgroundImageView)
        setupCollectionView()
    }

    private func setupCollectionView() {
        
        let collectionViewSize = CGSize(width: view.frame.width, height: view.frame.height - 88)
        let collectionViewOrigin = CGPoint(x: 0, y: 88)
        
        booksCollectionView = CollectionViewMaker.makeBookListCV(ofSize: collectionViewSize, with: "bookIcon")
        booksCollectionView?.frame.origin = collectionViewOrigin
        booksCollectionView?.delegate = self
        booksCollectionView?.dataSource = self
        view.addSubview(booksCollectionView!)
    }
    
    private func setupNavigationBar() {
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(presentSearchNotesVC))
        let addBookButton = UIBarButtonItem(title: "New book", style: .plain, target: self, action: #selector(presentAddBookVC))
        
        navigationItem.title = "Library"
        
        navigationItem.rightBarButtonItem = addBookButton
        navigationItem.leftBarButtonItem = searchButton
    }
    
    //Trigger functions
    @objc private func presentSearchNotesVC() {
        let vc = SearchNotesVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func presentAddBookVC() {
        let vc = AddBookVC()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension BookListVC: BookCellDelegate {
    
    func showZoomedBookCover(usingImage image: UIImage) {
        let vc = SnapshotHandlerVC(snapshot: image)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BookListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.listResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookIcon", for: indexPath) as! BookIconCell
        if let currentBook = dataSource.listResults?[indexPath.row] {
            cell.renderCell(_with: currentBook)
            cell.delegate = self
        }
        
        return cell
    }
}

extension BookListVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width * 0.4, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let books = dataSource.listResults else { print("error selecting book"); return }
        let selectedBook = books[indexPath.row]
        
        let bookVC = BookVC(book: selectedBook)
        navigationController?.pushViewController(bookVC, animated: true)
        
    }
    
}

