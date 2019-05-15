//
//  ItemCollectionViewCell.swift
//  LoLInfo
//
//  Created by Scarpz on 23/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var itemThumb: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    // MARK: - Methods
    /// Display the information of an Item in this cell
    ///
    /// - Parameter item: Item to get the information from
    func setup(item: Item) {
        
        let patch = PatchServices.getPatchFromUserDefaults()!
        
        if let validURL = URL(string: item.thumbURL.replacingOccurrences(of: "{{patch}}", with: patch)) {
            loadImage(with: validURL, options: NukeOptions.itemLoading, into: self.itemThumb)
        }

        self.itemPrice.text = item.price == 0 ? "Free" : "\(item.price)"
    }
    
}
