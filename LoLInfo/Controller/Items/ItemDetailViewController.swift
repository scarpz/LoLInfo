//
//  ItemDetailViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 27/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ItemDetailViewController: UITableViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var itemThumb: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemShortDescription: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    
    // MARK: - Properties
    var item: Item!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayItemInfo()
    }
}


// MARK: - Private Methods
extension ItemDetailViewController {
    
    /// Method responsible to display all the information of the Item
    private func displayItemInfo() {
        
        let patch = PatchServices.getPatchFromUserDefaults()!
        
        if let validURL = URL(string: self.item.thumbURL.replacingOccurrences(of: "{{patch}}", with: patch)) {
            loadImage(with: validURL, options: NukeOptions.itemLoading, into: self.itemThumb)
        }
        
        self.itemName.text = self.item.name
        self.itemPrice.text = item.price == 0 ? "Free" : "\(item.price)"
        self.itemShortDescription.text = self.item.shortDescription
        self.itemDescription.text = self.item.description
    }
}


// MARK: - Table View Methods
extension ItemDetailViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 209
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
