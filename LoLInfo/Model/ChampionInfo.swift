//
//  ChampionInfo.swift
//  LoLInfo
//
//  Created by Scarpz on 22/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

struct ChampionInfo {
    
    var attack: Int
    var defense: Int
    var magic: Int
    var difficulty: Int
    
    init(dict: [String : Any]) {
        self.attack = (dict["attack"] as? Int) ?? 0
        self.defense = (dict["defense"] as? Int) ?? 0
        self.magic = (dict["magic"] as? Int) ?? 0
        self.difficulty = (dict["difficulty"] as? Int) ?? 0
    }
}
