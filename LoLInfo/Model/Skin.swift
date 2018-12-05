//
//  Skin.swift
//  LoLInfo
//
//  Created by Scarpz on 22/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

struct Skin {
    
    var championStringId: String
    var id: Int
    var skinNumber: Int
    var name: String
    var splashURL: String
    var loadingURL: String
    
    init(championName: String, championStringId: String, dict: [String : Any]) {
        self.championStringId = championStringId
        self.id = Int((dict["id"] as? String ?? "0"))!
        self.skinNumber = (dict["num"] as? Int) ?? 0
        
        let nameString = (dict["name"] as? String) ?? ""
        self.name = nameString == "default" ? championName : nameString
        
        self.splashURL = BaseURL.championSplash.replacingOccurrences(of: "{{stringId}}", with: self.championStringId).replacingOccurrences(of: "{{skinNumber}}", with: "\(self.skinNumber)")
        
        self.loadingURL = BaseURL.championLoading.replacingOccurrences(of: "{{stringId}}", with: self.championStringId).replacingOccurrences(of: "{{skinNumber}}", with: "\(self.skinNumber)")
    }
}
