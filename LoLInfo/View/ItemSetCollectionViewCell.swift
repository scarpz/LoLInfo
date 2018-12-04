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
    @IBAction func deleteItem(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.deleteItem(in: self)
        }
    }
    
    
    
    // MARK: - Methods
    func setup(item: Item?, delegate: DeleteItemCellDelegate?) {
        
        self.delegate = delegate
        
        if let validItem = item {
            self.deleteView.isHidden = false
            self.layer.borderWidth = 2
            if let validURL = URL(string:validItem.thumbURL) {
                loadImage(with: validURL, options: NukeOptions.itemLoading, into: self.itemThumb)
            }
        } else {
            self.deleteView.isHidden = true
            self.layer.borderWidth = 0
            self.itemThumb.image = #imageLiteral(resourceName: "addItemIcon")
        }
    }

}
