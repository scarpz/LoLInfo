//
//  ItemTableViewCell.swift
//  LoLInfo
//
//  Created by Scarpz on 23/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ItemTableViewCell: UITableViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var itemThumb: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    // MARK: - Methods
    /// Display the information of an Item in this cell
    ///
    /// - Parameter item: Item to get the information from
    func setup(item: Item) {
        if let validURL = URL(string: item.thumbURL) {
            loadImage(with: validURL, options: NukeOptions.itemLoading, into: self.itemThumb)
        }
        self.itemName.text = item.name
        self.itemDescription.text = item.shortDescription
        self.itemPrice.text = item.price == 0 ? "Free" : "\(item.price)"
    }
}
