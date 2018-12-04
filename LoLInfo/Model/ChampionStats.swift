//
//  ChampionStats.swift
//  LoLInfo
//
//  Created by Scarpz on 22/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

struct ChampionStats {
    
    var hp: Double
    var hpPerLevel: Double
    var mp: Double
    var mpPerLevel: Double
    var moveSpeed: Double
    var armor: Double
    var armorPerLevel: Double
    var magicResist: Double
    var mrPerLevel: Double
    var attackDamage: Double
    var attackDamagePerLevel: Double
    
    init(dict: [String : Any]) {
        self.hp = dict["hp"] as? Double ?? 0
        self.hpPerLevel = dict["hpperlevel"] as? Double ?? 0
        self.mp = dict["mp"] as? Double ?? 0
        self.mpPerLevel = dict["mpperlevel"] as? Double ?? 0
        self.moveSpeed = dict["movespeed"] as? Double ?? 0
        self.armor = dict["armor"] as? Double ?? 0
        self.armorPerLevel = dict["armorperlevel"] as? Double ?? 0
        self.magicResist = dict["spellblock"] as? Double ?? 0
        self.mrPerLevel = dict["spellblockperlevel"] as? Double ?? 0
        self.attackDamage = dict["attackdamage"] as? Double ?? 0
        self.attackDamagePerLevel = dict["attackdamageperlevel"] as? Double ?? 0
    }
}
