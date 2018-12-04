//
//  ChampionServices.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

class ChampionServices {
    
    /// Method responsible to get all Champions
    ///
    /// - Parameter completion: Returns the list of Champions, if existing
    static func getAllChampions(completion: @escaping ([Champion]?) -> Void) {
        
        // Garantee the URL
        guard let url = URL(string: BaseURL.championList) else {
            completion(nil)
            return
        }
        
        // Perform the request
        RequestManager.request(url: url, method: .get, headers: nil, body: nil) { response, error in
            if let _ = error {
                completion(nil)
                
            } else if let validResponse = response {
                
                // Check the data of the response
                if let championsJson = validResponse["data"] as? [String : Any] {
                    
                    // Returns the parsed Champion list from the dictionary
                    completion(ResponseParser.parseChampionList(from: championsJson))
                    
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    /// Method responsible to retrieve all the information for a specific Champion
    ///
    /// - Parameters:
    ///   - stringId: String identification of the Champion
    ///   - completion: Returns the details of Champions, if existing
    static func getChampionDetail(by stringId: String, completion: @escaping (ChampionDetail?) -> Void) {
        
        // Setup the string of URL
        let baseURL = BaseURL.championDetail.replacingOccurrences(of: "{{stringId}}", with: stringId)
        
        // Garantee the URL
        guard let url = URL(string: baseURL) else {
            completion(nil)
            return
        }
        
        RequestManager.request(url: url, method: .get, headers: nil, body: nil) { response, error in
            if let _ = error {
                completion(nil)
                
            } else if let validResponse = response {
                
                // Check the data of the response
                if let data = validResponse["data"] as? [String : Any] {
                    
                    if let championKey = data.keys.first {
                        
                        // Get the first structure of the data of the Champion
                        if let championJson = data[championKey] as? [String : Any] {
                            
                            // Returns the parsed Champion Detail from the dictionary
                            completion(ResponseParser.parseChampionDetail(from: championJson))
                        } else {
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }    
                } else {
                    completion(nil)
                }
            }
        }
    }
}
