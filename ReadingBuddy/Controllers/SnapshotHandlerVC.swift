//
//  SnapshotHandlerVC.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 5/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

protocol ImageEditingDelegate: class {
    
    func save(_editedImage image: UIImage)
}

class SnapshotHandlerVC: UIViewController {
    
    var snapshot: UIImage
    
    var isEditingMode: Bool = false
    
    weak var imageEditingDelegate: ImageEditingDelegate?
    
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
    
    var drawingControlsView: DrawingControlsView!
    
    init(snapshot: UIImage) {
        self.snapshot = snapshot
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT snapshot VC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        setupBarButtons()
        setupNavigationBar()
        setupViews()
        updateMinZoomScaleForSize()
        
    }
    
    struct SnapshotHandlerBarButtons {
        let cancelButton: UIBarButtonItem
        let drawButton: UIBarButtonItem
        let saveButton: UIBarButtonItem
        let undoButton: UIBarButtonItem
    }
    
    var barButtons: SnapshotHandlerBarButtons!
    
    private func setupBarButtons() {
        barButtons = SnapshotHandlerBarButtons(
            cancelButton: UIBarButtonItem(title: "Cancel editing image", style: .plain, target: self, action: #selector(cancelEditingImage)),
            drawButton: UIBarButtonItem(image: UIImage(named: "pencilIcon"), style: .plain, target: self, action: #selector(startDrawing)),
            saveButton: UIBarButtonItem(image: UIImage(named: "checkmark"), style: .plain, target: self, action: #selector(saveEditedImage)),
            undoButton: UIBarButtonItem(image: UIImage(named: "undoIcon"), style: .plain, target: self, action: #selector(undoLastLineDrawn))
        )
    }

    private func setupNavigationBar() {
        
        if isEditingMode == true {
            navigationItem.leftBarButtonItem = barButtons.cancelButton
            navigationItem.rightBarButtonItems = [barButtons.saveButton, barButtons.drawButton]
        }
    }
    
    private func setupViews() {
        
        drawingControlsView = DrawingControlsView(frame: CGRect(origin: CGPoint(x: 0, y: 88), size: CGSize(width: view.frame.width, height: 60)))
        view.addSubview(drawingControlsView)
        drawingControlsView.delegate = self
        drawingControlsView.alpha = 0
        
        view.addSubview(imageScrollView)
        imageView.image = snapshot
        imageView.frame.size = snapshot.size
        //Setup scroll view and add image view as content
        let width = view.frame.width
        imageScrollView.frame = CGRect(x: view.frame.midX - width/2, y: view.frame.midY - width/2, width: width, height: width)
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
    
    @objc private func saveEditedImage() {
        let editedImage: UIImage?
        
        if let drawingImageView = drawingImageView {
            editedImage = getImageFromVisibleContext(in: drawingImageView)
        } else {
            editedImage = getImageFromVisibleContext(in: imageScrollView)
        }
        
        if let editedImage = editedImage {
            imageEditingDelegate?.save(_editedImage: editedImage)
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
    
    var drawingImageView: DrawingImageView?
    
    @objc private func startDrawing(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [barButtons.saveButton, barButtons.undoButton]
        
        guard let image = getImageFromVisibleContext(in: imageScrollView) else { return }
        
        drawingImageView = DrawingImageView(image: image)
        drawingImageView?.frame = imageScrollView.frame
        
        drawingControlsView.alpha = 1
        
        view.addSubview(drawingImageView!)
        imageScrollView.isHidden = true
    }
    
    @objc private func undoLastLineDrawn() {
        guard drawingImageView!.lines.count > 0 else { return }
        drawingImageView?.lines.removeLast()
        drawingImageView?.redraw()
    }
    
    @objc private func cancelEditingImage() {
        navigationController?.popViewController(animated: true)
    }

}

extension SnapshotHandlerVC: UIScrollViewDelegate {
    
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

extension SnapshotHandlerVC: DrawingControlsDelegate {
    
    func handleSize(_ change: SizeChange) {
        switch change {
            
        case .Increase:
            guard drawingImageView!.lineWidth < 10.0 else { return }
            drawingImageView?.lineWidth += 1
        case .Decrease:
            guard drawingImageView!.lineWidth > 1.0 else { return }
            drawingImageView?.lineWidth -= 1
            
        }
        
    }
    
    
    func handleColorSelected(_forColor color: UIColor) {
        drawingImageView?.lineColor = color.cgColor
        print(color)
    }
    
}
