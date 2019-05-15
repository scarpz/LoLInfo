//
//  ResponseParser.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

class ResponseParser {
    
    // MARK: - Champion Methods
    
    /// Method responsible to parse the data dictionary of the
    /// Champion List received from the server
    ///
    /// - Parameter dict: Server dictionary of Champion List
    /// - Returns: List of Champions parsed
    static func parseChampionList(from dict: [String : Any]) -> [Champion] {
        
        var allChampions = [Champion]()
        
        // Goes through all the Champions keys
        for key in dict.keys {
            
            // Guarantees it's a dictionary
            if let championDict = dict[key] as? [String : Any] {
                // Appends to the array a new Champion from it's dictionary
                allChampions.append(Champion(dict: championDict))
            }
        }

        // Sort by name and returns it
        return allChampions.sorted(by: { $0.name < $1.name })
    }
    
    /// Method responsible to parse the data dictionary of the
    /// Champion Detail received from the server
    ///
    /// - Parameter dict: Server dictionary of Champion Detail
    /// - Returns: Champion Detail parsed
    static func parseChampionDetail(from dict: [String : Any]) -> ChampionDetail {
        
        // Champion Name
        let championName = dict["name"] as? String ?? ""
        
        // Story
        let story = dict["lore"] as? String ?? ""
        
        // Champion String Id
        let championStringId = dict["id"] as? String ?? ""
        
        // Skins
        var skins = [Skin]()
        let skinsDict = dict["skins"] as? [[String : Any]] ?? [[:]]
        for skinDict in skinsDict {
            skins.append(Skin(championName: championName, championStringId: championStringId, dict: skinDict))
        }
        
        // Info
        let infoDict = dict["info"] as? [String : Any] ?? [:]
        let championInfo = ChampionInfo(dict: infoDict)
        
        let statsDict = dict["stats"] as? [String : Any] ?? [:]
        let championStats = ChampionStats(dict: statsDict)
        
        // Passive Skill
        let passiveDict = dict["passive"] as? [String : Any] ?? [:]
        let passiveSkill = Skill(type: .passive, dict: passiveDict)
        
        // Skills
        var skills = [Skill]()
        let skillsDict = dict["spells"] as? [[String : Any]] ?? [[:]]
        for skillIndex in 0..<skillsDict.count {
            switch skillIndex {
            case 0:
                skills.append(Skill(type: .q, dict: skillsDict[skillIndex]))
            case 1:
                skills.append(Skill(type: .w, dict: skillsDict[skillIndex]))
            case 2:
                skills.append(Skill(type: .e, dict: skillsDict[skillIndex]))
            case 3:
                skills.append(Skill(type: .r, dict: skillsDict[skillIndex]))
            default:
                break
            }
        }
        
        // Returns the Champion Detail
        return ChampionDetail(story: story, skins: skins, info: championInfo, stats: championStats, passive: passiveSkill, skills: skills)
    }
    
    
    // MARK: - Item Methods
    
    // Method responsible to parse the data dictionary of the
    /// Item List received from the server
    ///
    /// - Parameter dict: Server dictionary of Item List
    /// - Returns: List of Items parsed
    static func parseItemList(from dict: [String : Any]) -> [Item] {
        
        var allItems = [Item]()
        
        // Goes through all the keys of the dictionary
        for key in dict.keys {
            // Guarantees the data of this Item structure
            // and the int value of the key (given by the API)
            if let itemDict = dict[key] as? [String : Any], let itemId = Int(key) {
                // Append to the array a new Item from it's dictionary and key
                allItems.append(Item(id: itemId, dict: itemDict))
            }
        }

        // Sort by name and returns it
        return allItems.sorted(by: ({ $0.name < $1.name }))
    }
}
