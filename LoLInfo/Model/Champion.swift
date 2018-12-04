//
//  Champion.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

struct Champion {
    
    var id: Int
    var stringId: String
    var name: String
    var title: String
    var thumbURL: String {
        return "http://ddragon.leagueoflegends.com/cdn/\(Patch.patch)/img/champion/\(stringId).png"
    }
    var championDetail: ChampionDetail?
    
    
    init(dict: [String : Any]) {
        self.id = (dict["key"] as? Int) ?? 0
        self.stringId = (dict["id"] as? String) ?? ""
        self.name = (dict["name"] as? String) ?? ""
        self.title = (dict["title"] as? String) ?? ""
    }
}
