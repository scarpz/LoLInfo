//
//  ChampionCell.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ChampionCell: UICollectionViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var championThumb: UIImageView!
    @IBOutlet weak var championName: UILabel!
    

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Methods
    func setup(champion: Champion) {
        
        if let thumbURL = URL(string: champion.thumbURL) {
            loadImage(with: thumbURL, options: NukeOptions.championLoading, into: self.championThumb)
        }
        self.championName.text = champion.name
    }
}
