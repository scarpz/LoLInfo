//
//  StringExtension.swift
//  LoLInfo
//
//  Created by Scarpz on 27/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

extension String {
    
    /// Function responsible to format all the description from Riot API.
    /// The API returns the text with some HTML-ish tags and this method
    /// remove those tags
    ///
    /// - Returns: Formatted text
    func formatRiotDescription() -> String {
        
        var formattedString = ""
        var count = 0
        for char in self {
            switch char {
            case "<":
                count += 1
                break
            case ">":
                count -= 1
                break
                
            default:
                if count == 0 {
                    formattedString += String(char)
                }
                break
            }
        }
        return formattedString
    }
}
