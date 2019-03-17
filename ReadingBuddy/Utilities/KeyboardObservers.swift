//
//  TableViewCell.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 11/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

//private func setupKeyboardObserver() {
//    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//}
//
//@objc func handleKeyboardWillShow(notification: NSNotification) {
//    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
//        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
//    
//    let height = keyboardFrame.minY
//    let animationDistance = addBookView!.frame.maxY - height
//    
//    UIView.animate(withDuration: keyboardDuration) {
//        self.addBookView!.center.y -= animationDistance
//    }
//    
//}
//
//@objc func handleKeyboardWillHide(notification: NSNotification) {
//    guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
//    
//    UIView.animate(withDuration: keyboardDuration) {
//        self.addBookView!.center.y = self.view.center.y
//    }
//}
