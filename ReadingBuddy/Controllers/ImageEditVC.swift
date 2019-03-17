//
//  TableViewCell.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 11/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class ImageEditVC: UIViewController {
    
    var snapshot: UIImage
    
    var delegate: ImageEditingDelegate?
    
    let imageScrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.contentMode = .center
        return iv
    }()
    
    init(snapshot: UIImage) {
        self.snapshot = snapshot
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT imageedit VC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setupNavigationBar()
        setupViews()
        updateMinZoomScaleForSize()
    }
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))
    }
    
    private func setupViews() {
        
        view.addSubview(imageScrollView)
        imageView.image = snapshot
        imageView.frame.size = snapshot.size
        
        //Setup scroll view and add image view as content
        let width: CGFloat = 300.0
        let height: CGFloat = 450
        imageScrollView.frame = CGRect(x: view.frame.midX - width/2, y: view.frame.midY - height/2, width: width, height: height)
        imageScrollView.addSubview(imageView)
        imageScrollView.contentSize = imageView.bounds.size
        imageScrollView.delegate = self
    }
    
    private func updateMinZoomScaleForSize() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = imageScrollView.bounds.size
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        imageScrollView.minimumZoomScale = min(widthScale, heightScale)
        imageScrollView.maximumZoomScale = 1.5
        imageScrollView.zoomScale = min(widthScale, heightScale)
        
    }
    
    private func updateConstraintsForSize() {
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = imageScrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    @objc private func saveImage() {
        let editedImage: UIImage?

        editedImage = getImageFromVisibleContext(in: imageScrollView)
        
        if let editedImage = editedImage {
            delegate?.save(_editedImage: editedImage)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func getImageFromVisibleContext(in view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: view.bounds.size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

extension ImageEditVC: UIScrollViewDelegate {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateMinZoomScaleForSize()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize()
    }
}
