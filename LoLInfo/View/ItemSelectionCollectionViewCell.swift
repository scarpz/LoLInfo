//
//  ItemSelectionTableViewCell.swift
//  LoLInfo
//
//  Created by Scarpz on 30/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ItemSelectionTableViewCell: UITableViewCell {

    
    // MARK: - Outlets
    @IBOutlet weak var itemThumb: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Methods
    func setup(item: Item) {
        /// Display the information of an Item in this cell
        ///
        /// - Parameter item: Item to get the information from
        if let validURL = URL(string: item.thumbURL) {
            loadImage(with: validURL, options: NukeOptions.itemLoading, into: self.itemThumb)
        }
        self.itemName.text = item.name
    }
}
