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
    static func getAllChampions(champions: @escaping ([Champion]) -> Void, failure: @escaping (Error) -> Void) {
        
        PatchServices.getPatch(patch: { latestPatch in
            
            // Guarantees the URL
            guard let url = URL(string: BaseURL.championList.replacingOccurrences(of: "{{patch}}", with: latestPatch)) else {
                failure(Errors.urlParseError)
                return
            }
            
            // Performs the request
            RequestManager.request(url: url, method: .get, headers: nil, body: nil, success: { response in
                
                do {
                    // Gets a Dictionary value of the data received from the server
                    let json = try JSONSerialization.jsonObject(with: response, options: []) as! [String : Any]
                    
                    // Checks the data of the response
                    if let championsJson = json["data"] as? [String : Any] {
                        // Returns the parsed Item list from the dictionary
                        champions(ResponseParser.parseChampionList(from: championsJson))
                    } else {
                        failure(Errors.dictionaryParseError)
                    }
                } catch let error {
                    failure(error)
                }
            }) { error in
                failure(error)
            }
            
        }) { error in
            failure(error)
        }
    }
    
    
    /// Method responsible to retrieve all the information for a specific Champion
    ///
    /// - Parameters:
    ///   - stringId: String identification of the Champion
    ///   - completion: Returns the details of Champions, if existing
    static func getChampionDetail(by stringId: String, championDetail: @escaping (ChampionDetail) -> Void, failure: @escaping (Error) -> Void) {
        
        PatchServices.getPatch(patch: { latestPatch in
            
            // Setup the string of URL
            let baseURL = BaseURL.championDetail.replacingOccurrences(of: "{{stringId}}", with: stringId).replacingOccurrences(of: "{{patch}}", with: latestPatch)
            
            // Guarantees the URL
            guard let url = URL(string: baseURL) else {
                failure(Errors.urlParseError)
                return
            }
            
            // Perform the request
            RequestManager.request(url: url, method: .get, headers: nil, body: nil, success: { response in
                
                do {
                    // Gets a Dictionary value of the data received from the server
                    let json = try JSONSerialization.jsonObject(with: response, options: []) as! [String : Any]
                    
                    // Checks the data of the response
                    if let championJson = json["data"] as? [String : Any] {
                        
                        if let championKey = championJson.keys.first {
                            
                            // Gets the first structure of the data of the Champion
                            if let championJson = championJson[championKey] as? [String : Any] {
                                
                                // Returns the parsed Champion Detail from the dictionary
                                championDetail(ResponseParser.parseChampionDetail(from: championJson))
                            } else {
                                failure(Errors.dictionaryParseError)
                            }
                        } else {
                            failure(Errors.noValues)
                        }
                    } else {
                        failure(Errors.dictionaryParseError)
                    }
                } catch let error {
                    failure(error)
                }
            }) { error in
                failure(error)
            }
        }) { error in
            failure(error)
        }
    }
}
