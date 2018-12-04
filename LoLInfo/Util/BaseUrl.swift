//
//  BaseUrl.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

/// Struct to store all the base URLs of the request used in ths application
///
/// - championList: URL to get the Champion list
/// - championDetail: URL to get the Champion Detail
/// - itemList: URL to get the Item list
struct BaseURL {
    static let championList = "http://ddragon.leagueoflegends.com/cdn/\(Patch.patch)/data/en_US/champion.json"
    static let championDetail = "http://ddragon.leagueoflegends.com/cdn/\(Patch.patch)/data/en_US/champion/{{stringId}}.json"
    static let itemList = "http://ddragon.leagueoflegends.com/cdn/\(Patch.patch)/data/en_US/item.json"
}
