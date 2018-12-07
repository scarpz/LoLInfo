//
//  ChampionSelectionTableViewCell.swift
//  LoLInfo
//
//  Created by Scarpz on 29/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ChampionSelectionTableViewCell: UITableViewCell {

    
    // MARK: - Outlets
    @IBOutlet weak var championThumb: UIImageView!
    @IBOutlet weak var championName: UILabel!
    
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    // MARK: - Methods
    /// Display the information of a Champion in this cell
    ///
    /// - Parameter champion: Champion to get the information from
    func setup(champion: Champion) {
        if let validURL = URL(string: champion.thumbURL) {
            loadImage(with: validURL, options: NukeOptions.championLoading, into: self.championThumb)
        }
        self.championName.text = champion.name
    }
}
