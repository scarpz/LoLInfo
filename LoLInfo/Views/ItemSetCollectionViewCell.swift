//
//  ItemSetCollectionViewCell.swift
//  LoLInfo
//
//  Created by Scarpz on 30/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

protocol DeleteItemCellDelegate: class {
    func deleteItem(in cell: UICollectionViewCell)
}

class ItemSetCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var itemThumb: UIImageView!
    @IBOutlet weak var deleteView: UIButton!
    
    
    // MARK: - Properties
    weak var delegate: DeleteItemCellDelegate?
    
    
    // MARK: - Actions
    /// Mehod responsible to get the interaction of the de Delete Button.
    /// If it's pressed, delegate the action to the View Controller to delete an Item from the Collection View
    @IBAction func deleteItem(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.deleteItem(in: self)
        }
    }
    
    
    // MARK: - Methods
    /// Display the information of an Item in this cell
    ///
    /// - Parameter item: Item (optional) to get the information from
    ///   - delegate: Parameter to delegate those methods
    func setup(item: Item?, delegate: DeleteItemCellDelegate?) {
        
        self.delegate = delegate
        
        // If there is a valid item, display its image and also display the Delete Button
        if let validItem = item {
            self.deleteView.isHidden = false
            self.layer.borderWidth = 2
            if let validURL = URL(string:validItem.thumbURL) {
                loadImage(with: validURL, options: NukeOptions.itemLoading, into: self.itemThumb)
            }
        // Otherwise, fill the image with the Add Item placeholder, without the Delete Button
        } else {
            self.deleteView.isHidden = true
            self.layer.borderWidth = 0
            self.itemThumb.image = #imageLiteral(resourceName: "addItemIcon")
        }
    }

}
