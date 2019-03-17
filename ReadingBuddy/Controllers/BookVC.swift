//
//  BookVC.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 21/2/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class BookVC: UIViewController {
    
    let noteCellIdentifier = "noteCell"
    
    var selectedBook: Book
    
    var notesTableView: UITableView!
    
    private let dataSource = ListDataSource<Note>()
    
    init(book: Book) {
        self.selectedBook = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDataSource()
        configureTableView()
        setupNavigationBar()
    }
    
    deinit {
        dataSource.notification?.invalidate()
        print("BookVC deinit")
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.white
    }
    
    private func configureTableView() {
        notesTableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: 88), size: CGSize(width: view.frame.width, height: view.frame.height - 88)))
        notesTableView.register(NoteCell.self, forCellReuseIdentifier: noteCellIdentifier)
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        view.addSubview(notesTableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = selectedBook.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(presentNewNoteVC))
    }
    
    private func setupDataSource() {
        
        let predicate = NSPredicate(format: "bookId = %@", selectedBook.id)
        dataSource.fetchResultsFromRealm(withPredicate: predicate)
        
        let handler = { [unowned self] in
            self.notesTableView.reloadData()
        }
        dataSource.observeResults(handler())
    }
    
    //Handler functions
    @objc private func presentNewNoteVC() {
        let vc = NoteVC(bookId: selectedBook.id)
        navigationController?.pushViewController(vc, animated: true)
    }

    var zoomingView: ZoomingView?
    
    @objc func animateScreenshot(_ tapGesture: UITapGestureRecognizer) {
        
        guard let startingImageView = tapGesture.view as? UIImageView else { return }
        guard let startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil) else { return }
        
        zoomingView = ZoomingView(startingFrame: startingFrame, zoomingImage: startingImageView.image!, frame: self.view.frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomOutImage))
        zoomingView?.addGestureRecognizer(tapGesture)
        
        view.addSubview(zoomingView!)
        zoomingView?.zoomIn()
    }
    
    @objc private func zoomOutImage() {
        zoomingView?.zoomOut()
    }

}

extension BookVC: NoteCellDelegate {
    
    func showZoomedPageSnapshot(_ data: Data) {
        
    }
    
    func presentOptionsMenu(forCell cell: Int) {
        guard let tappedCell = notesTableView.cellForRow(at: IndexPath(item: cell, section: 0)) as? NoteCell else { return }
        
        let referenceFrame = notesTableView.convert(tappedCell.frame, to: view)
        let optionsFrame = CGRect(x: 20, y: referenceFrame.maxY - 88, width: view.frame.width - 40, height: 80)
        
        let vc = PopoverOptionsVC(frame: optionsFrame, itemIndex: cell)
        vc.delegate = self
        vc.preferredContentSize = CGSize(width: optionsFrame.width, height: optionsFrame.height)
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController!
        popover.delegate = self
        popover.backgroundColor = UIColor.black
        popover.permittedArrowDirections = .up
        popover.sourceView = self.view
        popover.sourceRect = optionsFrame
        
        present(vc, animated: true, completion: nil)
    }
    
}

extension BookVC: OptionsDelegate {
    
    func deleteNote(atIndex index: Int) {
        guard let note = dataSource.listResults?[index] else { return }
        dataSource.deleteObject(object: note)
    }
    
}

extension BookVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("dismissed")
    }
}

extension BookVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let note = dataSource.listResults?[indexPath.row] else { return }
        let vc = NoteVC(note: note)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BookVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.listResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: noteCellIdentifier) as! NoteCell
        guard let note = dataSource.listResults?[indexPath.row] else { return cell }
        cell.render(with: note)
        cell.optionsButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }

}
