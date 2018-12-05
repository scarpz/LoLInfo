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
    func setup(itemSetCoreData: ItemSetCoreData) {
        
        let championThumbString = BaseURL.championThumb.replacingOccurrences(of: "{{stringId}}", with: itemSetCoreData.championId)
        
        if let validChampionURL = URL(string: championThumbString) {
            loadImage(with: validChampionURL, options: NukeOptions.championLoading, into: self.championThumb)
        }
        
        self.itemSetName.text = itemSetCoreData.name
        
        for index in 0..<self.items.count {
            
            if itemSetCoreData.itemsId.indices.contains(index) {
                self.items[index].isHidden = false
                
                let itemThumbString = BaseURL.itemThumb.replacingOccurrences(of: "{{id}}", with: itemSetCoreData.itemsId[index])
                
                if let validItemURL = URL(string: itemThumbString) {
                    loadImage(with: validItemURL, options: NukeOptions.itemLoading, into: self.items[index])
                } 
            } else {
                self.items[index].isHidden = true
            }
        }

    }
}
