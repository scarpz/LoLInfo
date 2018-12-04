//
//  Item.swift
//  LoLInfo
//
//  Created by Scarpz on 23/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

struct Item {
    
    var id: Int
    var name: String
    var shortDescription: String
    var description: String
    var price: Int
    var thumbURL: String {
        return "http://ddragon.leagueoflegends.com/cdn/\(Patch.patch)/img/item/\(id).png"
    }
    
    init(id: Int, dict: [String : Any]) {
        self.id = id
        self.name = dict["name"] as? String ?? ""
        self.shortDescription = dict["plaintext"] as? String ?? ""
        
        var descriptionText = dict["description"] as? String ?? ""
        // This description come with those HTML-ish tags from API
        // and this replacing is used to format the text in the right
        // wat to be displayed in the view later
        descriptionText = descriptionText.replacingOccurrences(of: "<br>", with: "\n")
        descriptionText = descriptionText.formatRiotDescription()
        
        self.description = descriptionText
        
        let goldDict = dict["gold"] as? [String : Any] ?? [:]
        self.price = goldDict["total"] as? Int ?? 0
    }
}
