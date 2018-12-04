//
//  SkinCollectionViewCell.swift
//  LoLInfo
//
//  Created by Scarpz on 26/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class SkinCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var skinImage: UIImageView!
    
    
    // MARK: - Methods
    func setup(skin: Skin) {
        if let validURL = URL(string: skin.splashURL) {
            loadImage(with: validURL, options: NukeOptions.skinLoading, into: self.skinImage)
        }
    }
}
