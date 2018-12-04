//
//  ItemSetTableViewCell.swift
//  LoLInfo
//
//  Created by Scarpz on 28/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ItemSetTableViewCell: UITableViewCell {

    
    // MARK: - Outlets
    @IBOutlet weak var championThumb: UIImageView!
    @IBOutlet weak var itemSetName: UILabel!
    @IBOutlet var items: [UIImageView]!
    
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    // MARK: - Methods
    func setup(itemSet: ItemSet) {
        
        if let validChampionURL = URL(string: itemSet.champion.thumbURL) {
            loadImage(with: validChampionURL, options: NukeOptions.championLoading, into: self.championThumb)
        }
        
        self.itemSetName.text = itemSet.name
        
        for itemIndex in 0..<itemSet.items.count {
            if let validItemURL = URL(string: itemSet.items[itemIndex].thumbURL) {
                loadImage(with: validItemURL, options: NukeOptions.itemLoading, into: self.items[itemIndex])
            }
        }
    }
}
