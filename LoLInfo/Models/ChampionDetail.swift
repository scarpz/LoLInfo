//
//  ChampionDetail.swift
//  LoLInfo
//
//  Created by Scarpz on 22/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

struct ChampionDetail {
    
    var story: String
    var skins: [Skin]
    var info: ChampionInfo
    var stats: ChampionStats
    var passive: Skill
    var skills: [Skill]
}
