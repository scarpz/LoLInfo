//
//  SkinViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 26/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class SkinViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var skinName: UILabel!
    @IBOutlet weak var skinImage: UIImageView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    
    // MARK: - Properties
    var skin: Skin!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSkinView()
        self.display(skinURL: self.skin.splashURL)
    }
    
    
    // MARK: - Actions
    @IBAction func dismissSkin(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        
        self.scroll.zoomScale = 1
        
        if sender.selectedSegmentIndex == 0 {
            self.display(skinURL: self.skin.splashURL)
        } else {
            self.display(skinURL: self.skin.loadingURL)
        }
    }
    
    @IBAction func shareSkin(_ sender: UIBarButtonItem) {
        
        if let image = self.skinImage.image {
            let shareAlert = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(shareAlert, animated: true, completion: nil)
        }
    }
    
}


// MARK: - Private Methods
extension SkinViewController {
    
    private func setupSkinView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(zoom(_:)))
        tap.numberOfTapsRequired = 2
        
        self.skinImage.addGestureRecognizer(tap)
        
        self.scroll.delegate = self
        
        self.skinName.text = self.skin.name
    }
    
    private func display(skinURL: String) {
        if let validUrl = URL(string: skinURL) {
            loadImage(with: validUrl, options: NukeOptions.skinLoading, into: self.skinImage)
        }
    }
    
    @objc private func zoom(_ tap: UITapGestureRecognizer) {
        
        if self.scroll.zoomScale > (self.scroll.maximumZoomScale / 2) {
            self.scroll.setZoomScale(1, animated: true)
        } else {
            
            let point = tap.location(in: self.skinImage)
            let scrollViewSize = self.scroll.bounds.size
            
            let width = scrollViewSize.width / scroll.maximumZoomScale
            let height = scrollViewSize.height / scroll.maximumZoomScale
            let xPoint = point.x - (width/2.0)
            let yPoint = point.y - (height/2.0)
            
            let rect = CGRect(x: xPoint, y: yPoint, width: width, height: height)
            scroll.zoom(to: rect, animated: true)
            
            self.scroll.setZoomScale(5, animated: true)
        }
    }
}


// MARK: - Scroll Methods
extension SkinViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.skinImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        // Prevent from going out of bounds
        if scrollView.zoomScale > scrollView.minimumZoomScale {

            // TODO: -
            if let image = self.skinImage.image {
                
                let widthRatio = self.skinImage.frame.width / image.size.width
                let heightRatio = self.skinImage.frame.height / image.size.height
                
                let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
                
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale >
                    self.skinImage.frame.width ? (newWidth - self.skinImage.frame.width) :
                    (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale >
                    self.skinImage.frame.height ? (newHeight - self.skinImage.frame.height) :
                    (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
}
