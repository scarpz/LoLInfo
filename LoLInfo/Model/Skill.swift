//
//  Skill.swift
//  LoLInfo
//
//  Created by Scarpz on 22/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

enum SkillType {
    case passive
    case q
    case w
    case e
    case r
}

struct Skill {
    
    var type: SkillType
    var stringId: String
    var name: String
    var description: String
    var thumbURL: String
    
    init(type: SkillType, dict: [String : Any]) {
        self.type = type
        
        // This check is needed to use this structure as Passive and Active Skills
        // The Passive and Active Skills are in different nodes and need different
        // treatments.
        if type == .passive {
            let imageDict = dict["image"] as? [String : Any] ?? [:]
            let imageSuffix =  imageDict["full"] as? String ?? ""
            self.stringId = imageSuffix.components(separatedBy: ".png").first ?? ""
            self.thumbURL = BaseURL.passiveThumb.replacingOccurrences(of: "{{stringId}}", with: self.stringId)
        } else {
            self.stringId = dict["id"] as? String ?? ""
            self.thumbURL = BaseURL.skillThumb.replacingOccurrences(of: "{{stringId}}", with: self.stringId)
        }
        self.name = dict["name"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
    }
}
