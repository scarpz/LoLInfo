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
        self.scroll.delegate = self
        
        self.skinName.text = self.skin.name
    }
    
    private func display(skinURL: String) {
        if let validUrl = URL(string: skinURL) {
            loadImage(with: validUrl, options: NukeOptions.skinLoading, into: self.skinImage)
        }
    }
}


// MARK: - Scroll Methods
extension SkinViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.skinImage
    }
}
