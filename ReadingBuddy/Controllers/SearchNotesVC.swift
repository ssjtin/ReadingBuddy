//
//  SearchNotesVC.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 3/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

enum NoteSearchScope: String {
    case All
    case Headline
    case Content
    case Tags
}

class SearchNotesVC: UIViewController {
    
    var searchBar: UISearchBar?
    var searchScope: NoteSearchScope = .All
    
    var resultsTableView: UITableView?
    
    var tagPicker: TagPickerView?
    var uniqueTagList = [String]()
    
    let dataSource = SearchNotesDataSource<Note>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupViews()
        setupNavigationBar()
        setupDataSource()
    }
    
    deinit {
        print("search notes VC deinit")
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.white

        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: view.frame.height - 88)
        let searchNotesView = SearchNotesView(frame: frame)
        searchNotesView.delegate = self
        
        //Setup search bar
        searchBar = searchNotesView.searchBar
        searchBar?.delegate = self
        //Setup results tableView
        resultsTableView = searchNotesView.resultsTableView
        resultsTableView?.dataSource = self
        resultsTableView?.delegate = self
        
        view.addSubview(searchNotesView)

    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Search notes"
    }
    
    private func setupDataSource() {
        dataSource.tableView = resultsTableView
        dataSource.fetchResultsFromRealm(withPredicate: NSPredicate(value: true))
        dataSource.filteredResults = Array(dataSource.listResults!)
    }
    
}

extension SearchNotesVC: SearchNoteDelegate {
    
    func presentTagPicker() {
        uniqueTagList = dataSource.getTagList()
        guard uniqueTagList.count > 0 else { return }
        
        let width: CGFloat = 200
        let height: CGFloat = 300
        tagPicker = TagPickerView(frame: CGRect(origin: CGPoint(x: view.frame.midX - width/2, y: view.frame.midY - height/2), size: CGSize(width: width, height: height)))
        tagPicker?.picker.delegate = self
        tagPicker?.picker.dataSource = self
        tagPicker?.delegate = self
        tagPicker?.picker.selectRow(0, inComponent: 0, animated: false)
        
        view.addSubview(tagPicker!)
    }
    
    func setSearchScope(_ searchScope: NoteSearchScope) {
        self.searchScope = searchScope
    }
    
}

extension SearchNotesVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uniqueTagList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.text = "#\(uniqueTagList[row])"
        return label
    }
    
}

extension SearchNotesVC: TagPickerDelegate {
    
    func confirmSelection() {
        
        guard let row = tagPicker?.picker.selectedRow(inComponent: 0) else { return }
        let tag = uniqueTagList[row]
        searchBar?.text = "#\(tag)"
        
        dataSource.filterResults(using: "#\(tag)", in: .Tags)
        tagPicker.reset()
    }
    
    func cancelPicker() {
        uniqueTagList.removeAll()
        tagPicker.reset()
    }
    
}

extension SearchNotesVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchString = searchBar.text {
            dataSource.filterResults(using: searchString.lowercased(), in: searchScope)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            dataSource.filteredResults = Array(dataSource.listResults!)
        }
    }
    
}

extension SearchNotesVC: OptionsDelegate {
    
    func deleteNote(atIndex index: Int) {
        let note = dataSource.filteredResults[index]
        dataSource.filteredResults.remove(at: index)
        dataSource.deleteObject(object: note)
    }
}

extension SearchNotesVC: NoteCellDelegate {
    
    func showZoomedPageSnapshot(_ data: Data) {
        print("zooming")
        if let image = UIImage(data: data) {
            let snapshotHandlerVC = SnapshotHandlerVC(snapshot: image)
            navigationController?.pushViewController(snapshotHandlerVC, animated: true)
        }
    }
    
    func presentOptionsMenu(forCell cell: Int) {
        guard let tappedCell = resultsTableView?.cellForRow(at: IndexPath(item: cell, section: 0)) as? NoteCell else { return }
        
        let referenceFrame = resultsTableView!.convert(tappedCell.frame, to: view)
        print(referenceFrame)
        let optionsFrame = CGRect(x: 20, y: referenceFrame.maxY - 88, width: view.frame.width - 40, height: 80)
        
        print(optionsFrame)
        
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

extension SearchNotesVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("dismissed")
    }
}

extension SearchNotesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.filteredResults.count == 0 ? 1 : dataSource.filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataSource.filteredResults.count == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No results found"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! NoteCell
            cell.render(with: dataSource.filteredResults[indexPath.row])
            cell.optionsButton.tag = indexPath.row
            cell.delegate = self
            return cell
        }
    }
}

extension SearchNotesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = dataSource.filteredResults[indexPath.row]
        
        let noteVC = NoteVC(note: note)
        navigationController?.pushViewController(noteVC, animated: true)
        
    }
}
